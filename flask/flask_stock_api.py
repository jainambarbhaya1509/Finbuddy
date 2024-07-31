#fully working code for the flask server

from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
import yfinance as yf
from decimal import Decimal, getcontext
import redis
import json
from dotenv import load_dotenv
import os 

app = Flask(__name__)

# Load environment variables
load_dotenv()

# Redis connection details
REDIS_HOST = os.getenv('REDIS_HOST')
REDIS_PORT = int(os.getenv('REDIS_PORT'))
REDIS_PASSWORD = os.getenv('REDIS_PASSWORD')

# Initialize Redis client
client = redis.StrictRedis(
    host=REDIS_HOST,
    port=REDIS_PORT,
    password=REDIS_PASSWORD,
    ssl=True
)

# Set decimal precision
getcontext().prec = 28

def cache_response(key, data, ttl=None):
    """Cache the response data in Redis with an optional Time-To-Live (TTL)."""
    json_data = json.dumps(data)
    
    if ttl is not None:
        # Set cache with expiration
        client.setex(key, ttl, json_data)
    else:
        # Set cache without expiration
        client.set(key, json_data)


def get_cached_response(key):
    """Retrieve cached response from Redis."""
    cached_data = client.get(key)
    if cached_data:
        return json.loads(cached_data)
    return None

def get_stock_price(stock_names):
    stock_prices = {}
    for stock_name in stock_names:
        try:
            ticker = yf.Ticker(stock_name)
            todays_data = ticker.history(period='1d')
            if not todays_data.empty:
                stock_prices[stock_name] = Decimal(todays_data['Close'][0])
            else:
                stock_prices[stock_name] = 'No data available'
        except Exception as e:
            stock_prices[stock_name] = f'Error fetching data: {str(e)}'
    return stock_prices

def calculate_investment_value(invested_stocks):
    stock_names = [stock.get('symbol_name') for stock in invested_stocks]
    current_prices = get_stock_price(stock_names)

    total_invested = Decimal('0.0')
    total_current_value = Decimal('0.0')

    for stock in invested_stocks:
        purchased_price = Decimal(stock.get('purchased_price', '0.0'))
        symbol_name = stock.get('symbol_name')
        quantity = Decimal(stock.get('quantity', '0'))

        current_price = current_prices.get(symbol_name)
        if isinstance(current_price, str):  # Skip if there is an error message
            continue

        try:
            current_price = Decimal(current_price)
        except ValueError:
            current_price = Decimal('0.0')  # Set to 0 if conversion fails

        invested_amount = purchased_price * quantity
        current_amount = current_price * quantity

        total_invested += invested_amount
        total_current_value += current_amount

    return {
        'total_invested': round(float(total_invested), 2),
        'total_current_value': round(float(total_current_value), 2)
    }

def filter_news_by_stock(news_items, stocks):
    filtered_news = []

    for item in news_items:
        title = item.find('h2', class_='title').text.strip()
        description = item.find('div', class_='desc').text.strip()

        combined_text = (title + description).lower()
        matched_stocks = [stock_name for stock_name in stocks if stock_name.lower() in combined_text]

        if matched_stocks:
            filtered_news.append({
                'title': title,
                'date': item.find('span', class_='date').text.strip(),
                'description': description,
                'name': matched_stocks,
            })

    return filtered_news

@app.route('/fetch_news', methods=['POST'])
def fetch_news():
    data = request.get_json()
    
    if not data or 'stock_names' not in data:
        return jsonify({'error': 'No stock names provided in the request'}), 400
    
    stock_names = data['stock_names']
    
    if not isinstance(stock_names, list) or not all(isinstance(name, str) for name in stock_names):
        return jsonify({'error': 'Invalid stock names format. It should be a list of strings'}), 400
    
    if not stock_names:
        return jsonify({'error': 'Stock names list is empty'}), 400

    # Generate a unique cache key based on stock names
    cache_key = 'news_data_' + '_'.join(stock_names)
    cached_response = get_cached_response(cache_key)

    if cached_response:
        print("news coming chacning")
        return jsonify(cached_response)

    try:
        url = 'https://pulse.zerodha.com/'
        response = requests.get(url)
        
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            items = soup.find_all('li', class_='box item')
            filtered_news = filter_news_by_stock(items, stock_names)
            
            if not filtered_news:
                return jsonify({'message': 'No news found for the given stock names'}), 404
            
            cache_response(cache_key, filtered_news, ttl=1800)  # Cache the news data
            return jsonify(filtered_news)
        else:
            return jsonify({'error': f'Failed to retrieve data from URL. Status code: {response.status_code}'}), response.status_code
    except requests.RequestException as e:
        return jsonify({'error': f'Request failed: {str(e)}'}), 500

@app.route('/fetch_stock_price', methods=['POST'])
def fetch_stock_price():
    data = request.get_json()
    
    if not data or 'stock_names' not in data:
        return jsonify({'error': 'No stock names provided in the request'}), 400

    stock_names = data['stock_names']
    
    if not isinstance(stock_names, list) or not all(isinstance(name, str) for name in stock_names):
        return jsonify({'error': 'Invalid stock names format. It should be a list of strings'}), 400
    
    if not stock_names:
        return jsonify({'error': 'Stock names list is empty'}), 400

    stock_prices = {}
    
    for stock_name in stock_names:
        try:
            ticker = yf.Ticker(stock_name)
            todays_data = ticker.history(period='1d')
            if not todays_data.empty:
                stock_prices[stock_name] = todays_data['Close'][0]
            else:
                stock_prices[stock_name] = 'No data available'
        except Exception as e:
            stock_prices[stock_name] = f'Error fetching data: {str(e)}'
    
    return stock_prices

@app.route('/fetch_portfolio', methods=['POST'])
def fetch_portfolio():
    data = request.get_json()
    url = 'https://rapid-raptor-slightly.ngrok-free.app/api/investement/getUserstock'
    headers = {
        'userauth': request.headers.get('userauth'),
        'Content-Type': 'application/json'
    }
    
    try:
        # Static cache key for portfolio data
        redis_key = 'userStock:1'
        cached_response = get_cached_response(redis_key)

        if cached_response:
            print('Data from Redis')
            stocks_data = cached_response
        else:
            # Data not found in Redis, make an HTTP request to fetch it
            response = requests.get(url, headers=headers)
            response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
            stocks_data = response.json()

            # Store the fetched data in Redis for future use
            cache_response(redis_key, stocks_data)
        
        # Calculate investment value using the fetched data
        stocks_investment = calculate_investment_value(stocks_data)
        
        return jsonify(stocks_investment)
    
    except requests.RequestException as e:
        return jsonify({'error': f"Request failed: {str(e)}"}), 500
    except redis.RedisError as e:
        return jsonify({'error': f"Redis error: {str(e)}"}), 500
    except Exception as e:
        return jsonify({'error': f"An unexpected error occurred: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True)
