import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/models/transactions_modal.dart';
import 'package:d_chart/d_chart.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChartsController extends GetxController {
  RxList<OrdinalData> pieChartData = <OrdinalData>[].obs;
  RxList<DChartBarDataCustom> barChartData = <DChartBarDataCustom>[].obs;
  RxList<OrdinalData> loanPieChartData = <OrdinalData>[].obs;
  RxBool toggleplot = false.obs;

  void fetchTransactioBarGraphData() {
    Dio()
        .get("$baseUrl/api/transaction/categoriseTransaction",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data as List;
        List<DChartBarDataCustom> barChartDataList = data
            .map((item) => DChartBarDataCustom(
                  value: item['total_amount'],
                  label: item['description'],
                ))
            .toList();
        barChartData.assignAll(barChartDataList);
      } else {}
    }).onError((error, stackTrace) {});
  }

  void fetchTransactionPieChartData() {
    Dio()
        .get("$baseUrl/api/transaction/categoriseTransaction",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data as List;
        List<OrdinalData> pieChartDataList = data
            .map((item) => OrdinalData(
                  domain: item['description'],
                  measure: item['total_amount'],
                ))
            .toList();
        pieChartData.assignAll(pieChartDataList);
        List<DChartBarDataCustom> barChartDataList = data
            .map((item) => DChartBarDataCustom(
                  value: item['total_amount'],
                  label: item['description'],
                ))
            .toList();
        barChartData.assignAll(barChartDataList);
      } else {}
    }).onError((error, stackTrace) {});
  }

  void fetchLoanChartData() {
    Dio()
        .get("$baseUrl/api/loan/getLoan",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data as List;
        List<OrdinalData> pieChartDataList = data
            .map((item) => OrdinalData(
                  domain: item['type'].toString(),
                  measure: double.parse(item['base_amount']).toDouble(),
                ))
            .toList();
        loanPieChartData.assignAll(pieChartDataList);
      } else {}
    }).onError((error, stackTrace) {});
  }
}

class TransactionController extends GetxController {
  var transactions = <Transactions>[].obs;
  final ChartsController chartsController = Get.put(ChartsController());

  void fetchAllTransactions() {
    Dio()
        .get(
      "$baseUrl/api/transaction/getTransaction",
      options: Options(
        headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        chartsController.fetchTransactionPieChartData();
        chartsController.fetchTransactioBarGraphData();
        var data = response.data;
        if (data != null && data is List) {
          List<Transactions> transactionsList = data
              .map((item) => Transactions(
                    description: item['description'],
                    date: _formatDateTime(item['date']),
                    amount: item['amount'],
                    reciverName: item['receiver_name'],
                  ))
              .toList();
          transactions.assignAll(transactionsList);
        } else {}
      } else {}
    }).catchError((error) {});
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    return dateFormat.format(dateTime);
  }
}
