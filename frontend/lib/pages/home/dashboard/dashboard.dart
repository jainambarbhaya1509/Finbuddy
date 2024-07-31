import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/controllers/summary_controller.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:bobhack/pages/home/dashboard/balance.dart';
import 'package:bobhack/pages/home/dashboard/chat_bot.dart';
import 'package:bobhack/pages/home/dashboard/header.dart';
import 'package:bobhack/pages/home/dashboard/linked_accounts.dart';
import 'package:bobhack/pages/home/dashboard/overall_investment.dart';
import 'package:bobhack/pages/home/dashboard/portfolio_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BobDashboard extends StatefulWidget {
  const BobDashboard({super.key});

  @override
  State<BobDashboard> createState() => _BobDashboardState();
}

class _BobDashboardState extends State<BobDashboard> {
  final ChartsController chartsController = Get.put(ChartsController());
  final SummaryController summaryController = Get.put(SummaryController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BobHeader(),
          const SizedBox(
            height: 30,
          ),
          LinkedAccounts(),
          const SizedBox(
            height: 30,
          ),
          YourBalance(),
          const SizedBox(
            height: 30,
          ),
          OverallInvestment(),
          const SizedBox(
            height: 30,
          ),
          const ChatBot(),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                Get.to(() => PortfolioSummary());
                chartsController.fetchTransactionPieChartData();
                chartsController.fetchLoanChartData();
                summaryController.getPortfolioSummary();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: const Text(
                  "Generate Portfolio Summary",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.05,
            endIndent: MediaQuery.of(context).size.width * 0.05,
            color: Colors.grey,
            thickness: 0.5,
          ),
          Container(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {
                  LoginController().deleteSessionKey();
                  Get.back();
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    ));
  }
}
