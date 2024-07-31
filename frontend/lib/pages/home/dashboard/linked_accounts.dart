import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinkedAccounts extends StatelessWidget {
  LinkedAccounts({super.key});

  final InvestmentController investmentController =
      Get.put(InvestmentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Linked Accounts",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Obx(() => Row(
                children: [
                  const Text(
                    "Bank of Baroda",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: subTextColor),
                  ),
                  const Spacer(),
                  Text(
                    displayAccountNumber(investmentController.personalDetails["account_number"]),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: subTextColor),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
