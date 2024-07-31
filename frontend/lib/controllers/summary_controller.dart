import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SummaryController extends GetxController {
  final profileSummary = ''.obs;
  final loading = false.obs; // Add this line
  final ChartsController chartsController = Get.put(ChartsController());

  @override
  void onClose() {
    super.onClose();
    profileSummary.value = '';
    chartsController.dispose();
  }

  void getPortfolioSummary() async {
    loading.value = true; // Start loading
    try {
      final response = await Dio().get(
        '$baseUrl/api/chatBot/portfolioSummary',
        options: Options(headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        }),
      );
      if (response.statusCode == 200) {
        profileSummary.value = response.data;
      }
    } finally {
      loading.value = false; // End loading
    }
  }
}
