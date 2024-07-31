import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/models/bot_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinBuddyBotController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final TextEditingController messageController = TextEditingController();

  RxList<FinBuddyBotModel> chatList = <FinBuddyBotModel>[].obs;

  final isLoading = false.obs;

  var endUrl = "chat";
  RxBool showGuide = false.obs;
  void getBotResponse(String userMessage) {
    messageController.clear();

    isLoading.value = true;

    if (userMessage.contains("@transaction")) {
      endUrl = "transaction";
      userMessage = userMessage.replaceAll("@transaction", "");
    } else if (userMessage.contains("@loans")) {
      endUrl = "loans";
      userMessage = userMessage.replaceAll("@loans", "");
    } else if (userMessage.contains("@investment")) {
      endUrl = "investment";
      userMessage = userMessage.replaceAll("@investment", "");
    } else {
      endUrl = "chat";
      userMessage = userMessage;
    }

    if (userMessage.isEmpty) {
      Get.snackbar(
        "Warning",
        "Please enter a message after @$endUrl",
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    chatList.add(
      FinBuddyBotModel(message: userMessage, isUser: true),
    );

    Dio()
        .get(
      "$baseUrl/api/chatBot/$endUrl/$userMessage",
      options: Options(
        headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        },
      ),
    )
        .then((response) {
      if (response.data["error"] != "null") {
        String botResponse = response.data['message'];

        chatList.add(
          FinBuddyBotModel(message: botResponse, isUser: false),
        );
      }
    }).catchError((error) {
      String errorMessage = "Error: ${error.toString()}";

      chatList.add(
        FinBuddyBotModel(message: errorMessage, isUser: false),
      );
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
