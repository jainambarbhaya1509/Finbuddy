from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
import yfinance as yf
from decimal import Decimal
from dotenv import load_dotenv
from datetime import datetime, timedelta
from ollama import chat
from pydantic import BaseModel

class MutualFunds (BaseModel):
    fund_age_yr: int
    risk_level: int
    returns_1yr: int

app = Flask(__name__)

# Load environment variables
load_dotenv()  

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

    try:
        url = 'https://pulse.zerodha.com/'
        response = requests.get(url)
        
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            items = soup.find_all('li', class_='box item')
            filtered_news = filter_news_by_stock(items, stock_names)
            
            
            if not filtered_news:
                return jsonify({'message': 'No news found for the given stock names'}), 404
            
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
    url = 'https://wondrous-ray-lightly.ngrok-free.app/api/investement/getUserstock'
    
    # Extract 'userauth' from the request body
    userauth = data.get('userauth')
    headers = {
        'userauth': userauth,
        'Content-Type': 'application/json'
    }
    
    try:
        # Make an HTTP request to fetch the stocks data
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
        stocks_data = response.json()

        # Calculate investment value using the fetched data
        stocks_investment = calculate_investment_value(stocks_data)
        
        return jsonify(stocks_investment)
    
    except requests.RequestException as e:
        return jsonify({'error': f"Request failed: {str(e)}"}), 500
    except Exception as e:
        return jsonify({'error': f"An unexpected error occurred: {str(e)}"}), 500

def fetch_stock_data(ticker):
    # Calculate date range for the past 1 year
    end_date = datetime.today()
    start_date = end_date - timedelta(days=365)  # 365 days for 1 year

    # Fetch historical data
    stock_data = yf.download(ticker, start=start_date, end=end_date, interval='1d')

    # Prepare data in array of objects format
    history = []
    for date, row in stock_data.iterrows():
        history.append({
            "date": date.strftime("%Y-%m-%d"),
            "price": row["Close"]  # Using 'Close' as the last traded price (LTP)
        })
    
    return history

@app.route('/stock_data', methods=['GET'])
def get_stock_data():
    ticker = request.args.get('ticker')
    if not ticker:
        return jsonify({"error": "Ticker parameter is required"}), 400
    
    try:
        stock_history = fetch_stock_data(ticker)
        return jsonify(stock_history)
    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/mutual_fund_ai', methods=['POST'])
def generate_response():
    # Get the JSON data from the request
    data = request.json
    user_query = data.get('query')
    if not user_query:
        return jsonify({"error": "No query provided"}), 400

    try:
        print(1)
        # Create an instance of the GenerativeModel
        response = chat(
            model="llama3.2",
            stream=False,
            messages=user_query,
            format=MutualFunds.model_json_schema()
        )
        print(2)
        print(response['message']['content'])

        
        # Return the generated response
        return jsonify({"message": response['message']['content']})
    except Exception as e:
        print(3)
        print(e)
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500



if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8000)
