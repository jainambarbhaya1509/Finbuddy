import 'dart:async';

import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/models/stocks_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class StocksController extends GetxController {
  RxList<StocksModel> investedStocks = <StocksModel>[].obs;
  final stockData = <Map<String, dynamic>>[].obs;

  final stocksInvestment = {}.obs;

  // Add loading state
  RxBool isLoading = false.obs;

  Future<void> getInvestedStocks() async {
    isLoading.value = true;
    try {
      final response = await Dio().get(
        "$baseUrl/api/investement/getUserstock",
        options: Options(
          headers: {"userauth": Get.find<LoginController>().sessionToken},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Map<String, dynamic>> stocks = data.map((item) {
          return {
            'id': item['id'],
            'symbol_name': item['symbol_name'],
            'purchased_price': item['purchased_price'],
            'quantity': item['quantity'],
            'stock_name': item['stock_name'],
          };
        }).toList();

        stockData.value = stocks;
      }
    } finally {
      await getStocksCurrentPrice();
    }
  }

  Future<void> getStocksCurrentPrice() async {
    try {
      final response = await Dio().post(
        "$stockBaseUrl/fetch_stock_price",
        data: {"stock_names": stockData.map((e) => e['symbol_name']).toList()},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> prices = response.data;
        investedStocks.value = stockData.map((stock) {
          final currentPrice = prices[stock['symbol_name']];
          return StocksModel(
            id: stock['id'],
            symbolName: stock['symbol_name'],
            purchasedPrice: stock['purchased_price'],
            quantity: stock['quantity'],
            stockName: stock['stock_name'],
            currentPrice: currentPrice,
          );
        }).toList();
      } else {}
    } finally {
      await calculateStockInvestment();
    }
  }

  Future<void> calculateStockInvestment() async {
    double totalInvested = 0.0;
    double totalCurrentValue = 0.0;

    for (var stock in investedStocks) {
      final purchasedPrice = double.tryParse(stock.purchasedPrice) ?? 0.0;
      final currentPrice =
          double.tryParse(stock.currentPrice.toString()) ?? 0.0;
      final quantity = stock.quantity.toDouble();

      final investedAmount = purchasedPrice * quantity;
      final currentAmount = currentPrice * quantity;

      totalInvested += investedAmount;
      totalCurrentValue += currentAmount;
    }

    final totalPL = totalCurrentValue - totalInvested;
    final totalPLPercentage =
        totalInvested > 0 ? (totalPL / totalInvested) * 100 : 0.0;

    stocksInvestment.value = {
      'total_invested_amount': totalInvested.toDouble(),
      'total_current_value': totalCurrentValue.toDouble(),
      'overall_PL': totalPL,
      'overall_PL_percentage': totalPLPercentage.toStringAsFixed(2),
    };

    isLoading.value = false; // Set loading state to false after calculation
  }

  final stockNews = {}.obs;
  final stockAnalyis = ''.obs;
  final isLoadingNews = false.obs;
  final isLoadingAnalysis = false.obs;

  void fetchInvestedStockNews(String stockName, int stockId) {
    isLoadingNews.value = true;
    isLoadingAnalysis.value = true;

    Dio()
        .post("$stockBaseUrl/fetch_news", data: {
          "stock_names": [stockName]
        })
        .then((response) async {
          if (response.statusCode == 200) {
            final data = await response.data[0];
            stockNews.value = data;
          } else {}
        })
        .catchError((error) {})
        .whenComplete(() {
          fetchStockAnalysis(stockId);
        });
  }

  void fetchStockAnalysis(int stockId) {
    Dio()
        .get("$baseUrl/api/chatBot/stockAnalyse/$stockId",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken
            }))
        .then((response) {
          if (response.statusCode == 200) {
            if (response.data["error"] == null) {
              stockAnalyis.value = response.data['message'];
            }
          } else {}
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {
          if (stockAnalyis.value.isNotEmpty && stockNews.isNotEmpty) {
            isLoadingAnalysis.value = false;
            isLoadingNews.value = false;
          }
        });
  }
}
