import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/controllers/stocks_controller.dart';
import 'package:bobhack/models/mutual_funds_modal.dart';
import 'package:bobhack/pages/home/investment/your_funds.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InvestmentController extends GetxController {
  var selectedInvestment = 'Mutual Fund'.obs;

  final RxBool isLoading = false.obs; // Loading state

  final StocksController stocksController = Get.put(StocksController());
  // Personal Details
  final personalDetails = {}.obs;
  final overallInvestment = {}.obs;
  final name = ''.obs;

  // Invested mutual funds
  final investedMutualFundsList = <InvestedMutualFundModel>[].obs;
  final mutualFundInvestment = {}.obs;
  final stockFundInvestment = {}.obs;

  void changeSelectedInvestment(String newInvestment) {
    if(newInvestment == 'Stock') {
      stocksController.getInvestedStocks();
    }
    else{
      getInvestedMutualFunds();
    }
    selectedInvestment.value = newInvestment;
  }

  void getUserPortfolio(Map response) {
    final financialData = response;

    double totalInvestedAmount =
        financialData["total_invested_amount"].toDouble();
    double totalCurrentValue = financialData["total_current_value"].toDouble();

    // Calculate P&L
    double overallPL = totalCurrentValue - totalInvestedAmount;

    // Calculate P&L percentage
    double overallPLPercentage = (overallPL / totalInvestedAmount) * 100;

    // Add to overall investment data
    overallInvestment.value = {
      "total_invested_amount": totalInvestedAmount,
      "total_current_value": totalCurrentValue,
      "overall_PL": overallPL,
      "overall_PL_percentage": overallPLPercentage.toStringAsFixed(2),
    };

    // Personal Data
    final personalData = response["personal_details"];
    personalDetails.value = personalData;

    name.value = response["name"];
  }

  Future<void> getInvestedMutualFunds() async {
    Dio()
        .get(
      '$baseUrl/api/investement/getUserMutualFunds',
      options: Options(
        headers: {'userauth': Get.find<LoginController>().sessionToken},
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = response.data["investment_details"] as List<dynamic>;

        final mutualFundInvestmentData = response.data["totals"];

        double totalInvestedAmount =
            mutualFundInvestmentData["total_invested_amount"].toDouble();
        double totalCurrentValue =
            mutualFundInvestmentData["total_current_value"].toDouble();

        // Calculate P&L
        double overallPL = totalCurrentValue - totalInvestedAmount;

        // Calculate P&L percentage
        double overallPLPercentage = (overallPL / totalInvestedAmount) * 100;

        // Add to overall investment data
        mutualFundInvestment.value = {
          "total_invested_amount": totalInvestedAmount,
          "total_current_value": totalCurrentValue,
          "overall_PL": overallPL,
          "overall_PL_percentage": overallPLPercentage.toStringAsFixed(2),
        };

        investedMutualFundsList.assignAll(
          data.map((fund) {
            return InvestedMutualFundModel(
              // investmentDate: DateFormat('yyyy-MM-dd').parse(fund['investment_date']),
              // purchasedPrice: fund['purchased_price'],
              investmentAmount:
                  double.parse(fund['investment_amount']).toDouble(),
              unitsPurchased: fund['units_purchased'],
              currentValue: fund['current_value'],
              fundName: fund['fund_name'],
            );
          }).toList(),
        );
      }
    }).onError((error, stackTrace) {
    }).whenComplete(() {
      isLoading.value = false;
      Get.to((() => const YourFunds()));
    });
  }
}

class MutualFundsController extends GetxController {
  List<MutualFunds> mutualFunds = <MutualFunds>[].obs;
  final TextEditingController mutualFundSearchController =
      TextEditingController();
  final RxBool isLoading = false.obs;
  RxString mutualFundInfoMessage = ''.obs;
  final searchType = 'genai'.obs;

  var term = ''.obs;
  var risk = ''.obs;
  var returns = ''.obs;

  void toggleSearchType() {
    searchType.value = searchType.value == 'genai' ? 'amc' : 'genai';
    if (searchType.value == 'genai') {
      mutualFunds.clear();
    } else {
      fetchAllMutualFunds();
    }
  }

  void searchMutualFunds(String query) {
    if (query.isEmpty) {
      fetchAllMutualFunds();
    } else {
      mutualFunds.assignAll(
        mutualFunds.where((fund) {
          return fund.name.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  void fetchAllMutualFunds() {
    final query = mutualFundSearchController.text.trim();
    final url = '$baseUrl/api/investement/getAllMutualFunds/$query';

    Dio()
        .get(
      url,
      options: Options(
          headers: {'userauth': Get.find<LoginController>().sessionToken}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        mutualFunds.assignAll(
          data.map((fund) {
            return MutualFunds(
              name: fund['amc_name'].toString(),
              age: fund['fund_age_yr'].toString(),
              category: fund['category'].toString(),
              size: fund['fund_size_cr'].toString(),
            );
          }).toList(),
        );
      } else {
        throw Exception(
            'Failed to load mutual funds, status code: ${response.statusCode}');
      }
    }).catchError((e) {
      if (e is DioException && e.response != null) {
        final statusCode = e.response!.statusCode;
        throw Exception(
            'Error fetching mutual funds: ${e.message}, status code: $statusCode');
      } else {
        throw Exception('Error fetching mutual funds: $e');
      }
    }).whenComplete(() {
      isLoading.value = false; // Hide loader
    });
  }

  void fetchMutualFundsWithGenAI() {
    final query = mutualFundSearchController.text.trim();
    final url = '$baseUrl/api/investement/mutualFundsPrompt/$query';

    // Set loading to true to show the loader
    isLoading.value = true;
    mutualFundInfoMessage.value = '';
    mutualFunds.clear();
    Dio()
        .get(
      url,
      options: Options(
          headers: {'userauth': Get.find<LoginController>().sessionToken}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data['message'] != null) {
            mutualFundInfoMessage.value = data['message'];
          } else {
            term.value = data['fund_age_yr'];
            risk.value = data['risk_range'];
            returns.value = data['returns_1yr'];

            if (data["mutualData"] is List<dynamic>) {
              mutualFunds.assignAll(
                (data["mutualData"] as List<dynamic>).map((fund) {
                  return MutualFunds(
                    name: fund['scheme_name']?.toString() ?? 'Unknown',
                    age: fund['fund_age_yr']?.toString() ?? 'N/A',
                    category: fund['category']?.toString() ?? 'N/A',
                    size: fund['fund_size_cr']?.toString() ?? 'N/A',
                  );
                }).toList(),
              );
            }
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load mutual funds, status code: ${response.statusCode}');
      }
    }).catchError((e) {
      if (e is DioException && e.response != null) {
        final statusCode = e.response!.statusCode;
        throw Exception(
            'Error fetching mutual funds: ${e.message}, status code: $statusCode');
      } else {
        throw Exception('Error fetching mutual funds: $e');
      }
    }).whenComplete(() {
      // Set loading to false to hide the loader
      isLoading.value = false;
      mutualFundSearchController.clear();
    });
  }
}
