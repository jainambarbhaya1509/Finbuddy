import 'dart:async';

import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/controllers/services.dart';
import 'package:bobhack/pages/home/home.dart';
import 'package:bobhack/pages/login/bob_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final InvestmentController investmentController =
      Get.put(InvestmentController());

  String? errorMessage;
  String? sessionToken;
  bool sessionExists = false;

  final counter = 0.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    getSessionKey();
    super.onInit();
  }

  Future<void> saveSessionKey(String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionCookie', cookie);
    sessionToken = cookie;
    sessionExists = true;
  }

  Future<String?> getSessionKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionToken = prefs.getString('sessionCookie');
    sessionExists = sessionToken != null;
    return sessionToken;
  }

  Future<void> deleteSessionKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionCookie');
    sessionToken = null;
    sessionExists = false;
    pinController.clear();
    Get.offAll(() => BobLogin());
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      errorMessage = 'Please enter your account number';
    } else if (value.replaceAll(' ', '').length != 16) {
      errorMessage = 'Account number must be 16 digits';
    } else {
      errorMessage = null;
    }
    return errorMessage;
  }

  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      errorMessage = 'Please enter your PIN';
    } else if (value.length != 4) {
      errorMessage = 'PIN must be 4 digits';
    } else {
      errorMessage = null;
    }
    return errorMessage;
  }

  void loginWithPin() {
    if (validatePin(pinController.text) == null) {
      isLoading.value = true; // Start loader
      Dio dio = Dio();
      dio.post('$baseUrl/api/auth/validateUser', data: {
        "accountNumber": sessionToken,
        'pin': int.parse(pinController.text),
      }).then((response) {
        if (response.data['error'] == "Session Expired" &&
            response.data['valid'] == false) {
          deleteSessionKey();
          Get.snackbar(
            colorText: Colors.white,
            'Error',
            response.data["error"] as String,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );

          return;
        } else if (response.data["valid"] == false) {
          Get.snackbar(
            colorText: Colors.white,
            'Invalid Credentials',
            response.data["error"] as String,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );
          counter.value++;
          if (counter.value == 4) {
            Get.snackbar(
              colorText: Colors.white,
              'Too many attempts please login again',
              response.data["error"] as String,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
            );
            deleteSessionKey();
            Get.back();
            counter.value = 0;
          }
          return;
        }

        Get.snackbar(
          colorText: Colors.white,
          'Success',
          'Login successful!',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        Get.off(
          () => const BobHome(),
          curve: Curves.easeIn,
          duration: const Duration(
            milliseconds: 500,
          ),
        );
        investmentController.getUserPortfolio(response.data);
      }).catchError((error) {
        // Handle error
      }).whenComplete(() {
        isLoading.value = false; // Stop loader
        pinController.clear();
      });
    } else {
      Get.snackbar(
        colorText: Colors.white,
        'Error',
        errorMessage ?? 'An error occurred',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Timer? cooldownTimer;
  DateTime? _lastAttemptTime;
  static const int cooldownDurationMinutes = 3;

  void login() {
    if (errorMessage == null) {
      if (sessionExists) {
        loginWithPin();
        return;
      }

      // Check if user is in cooldown
      if (_isInCooldown()) {
        Get.snackbar(
          colorText: Colors.white,
          'Cooldown',
          'You need to wait before trying again.',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      isLoading.value = true; // Start loader
      Dio().post('$baseUrl/api/auth/createUser', data: {
        'accountNumber': int.parse(accountController.text.replaceAll(" ", '')),
        'pin': int.parse(pinController.text),
      }).then((response) async {
        if (response.data['error'] != null) {
          Get.snackbar(
            colorText: Colors.white,
            'Error',
            response.data["error"] as String,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );
          counter.value++;

          if (counter.value == 4) {
            _startCooldown();
            Get.snackbar(
              colorText: Colors.white,
              'Too many attempts',
              'Please wait before trying again.',
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
            );
          }
          return;
        }

        counter.value = 0;
        _lastAttemptTime = null;
        saveSessionKey(response.data['token']);
        WebSocketManager().initializeService();

        Get.snackbar(
          colorText: Colors.white,
          'Success',
          'Login successful!',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );

        Get.off(
          () => const BobHome(),
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500),
        );
        investmentController.getUserPortfolio(response.data);
      }).whenComplete(() {
        isLoading.value = false; // Stop loader
        accountController.clear();
        pinController.clear();
      });
    }
  }

  bool _isInCooldown() {
    if (_lastAttemptTime == null) return false;

    final now = DateTime.now();
    final durationSinceLastAttempt = now.difference(_lastAttemptTime!);
    return durationSinceLastAttempt <
        const Duration(minutes: cooldownDurationMinutes);
  }

  void _startCooldown() {
    _lastAttemptTime = DateTime.now();
    cooldownTimer =
        Timer(const Duration(minutes: cooldownDurationMinutes), () {});
  }

  @override
  void onClose() {
    accountController.dispose();
    pinController.dispose();
    super.onClose();
  }
}
