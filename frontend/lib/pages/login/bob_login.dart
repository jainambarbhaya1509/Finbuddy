import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BobLogin extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  BobLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginController.getSessionKey(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: SpinKitWaveSpinner(color: primaryColor),
            ),
          );
        }

        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
              child: Obx(
            () => loginController.isLoading.isTrue
                ? const SpinKitWaveSpinner(color: primaryColor)
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xff2B2B2B),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.moneyBillTrendUp,
                              color: subTextColor,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Welcome to FinBuddy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: const Color(0xff2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Enter your credentials",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 169, 169, 169),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (!loginController.sessionExists)
                                TextFormField(
                                  controller: loginController.accountController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: 'Account number',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                    AccountNumberInputFormatter(),
                                  ],
                                  validator:
                                      loginController.validateAccountNumber,
                                ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: loginController.pinController,
                                style: const TextStyle(color: Colors.white),
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: 'Pin',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                validator: loginController.validatePin,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(primaryColor),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff2B2B2B)),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  onPressed: () {
                                    if (loginController.sessionExists) {
                                      loginController.loginWithPin();
                                    } else {
                                      loginController.login();
                                    }
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          )),
        );
      },
    );
  }
}

class AccountNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) newText.write(' ');
      newText.write(text[i]);
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: newValue.selection.copyWith(
        baseOffset:
            newValue.selection.baseOffset + newText.length - text.length,
        extentOffset:
            newValue.selection.extentOffset + newText.length - text.length,
      ),
    );
  }
}
