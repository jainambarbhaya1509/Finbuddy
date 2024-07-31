import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:bobhack/pages/home/dashboard/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YourBalance extends StatelessWidget {
  YourBalance({super.key});

  final TransactionController transactionController =
      Get.put(TransactionController());

  final InvestmentController investmentController =
      Get.put(InvestmentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Balance",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.all(3),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  transactionController.fetchAllTransactions();
                  Get.to(() => RecentTransactions());
                },
                child: const Text(
                  "Transactions",
                ),
              )
            ],
          ),
          const Spacer(),
          Text(
            formatter.format(
                investmentController.personalDetails["balance"]),
            style: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
