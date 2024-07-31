import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/controllers/stocks_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PAndL extends StatelessWidget {
  PAndL({super.key});

  final InvestmentController investmentController =
      Get.put(InvestmentController());

  final StocksController stocksController = Get.put(StocksController());
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Investments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => DropdownButton<String>(
                  value: investmentController.selectedInvestment.value,
                  dropdownColor: Colors.grey[850],
                  style: const TextStyle(color: Colors.white),
                  items: ['Mutual Fund', 'Stock'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    investmentController.changeSelectedInvestment(newValue!);
                  },
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'P&L',
                style: TextStyle(
                  color: Color(0xff878787),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    final overallPL =
                        investmentController.selectedInvestment.value ==
                                "Mutual Fund"
                            ? investmentController
                                    .mutualFundInvestment['overall_PL'] ??
                                0
                            : stocksController.stocksInvestment['overall_PL'];
                    return Text(
                      formatter.format(overallPL),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(width: 15),
                  Obx(() {
                    final overallPLPercentage =
                        investmentController.selectedInvestment.value ==
                                "Mutual Fund"
                            ? investmentController.mutualFundInvestment[
                                    'overall_PL_percentage'] ??
                                0
                            : stocksController
                                .stocksInvestment['overall_PL_percentage'];
                    return Text(
                      "$overallPLPercentage%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(width: 5),
                  Obx(
                    () => investmentController
                                .mutualFundInvestment['total_invested_amount'] >=
                            investmentController
                                .mutualFundInvestment['total_current_value']
                        ? const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.red,
                            size: 20,
                            weight: 100,
                          )
                        : const Icon(
                            Icons.arrow_drop_up_sharp,
                            color: Colors.green,
                            size: 20,
                            weight: 100,
                          ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color.fromARGB(255, 87, 87, 87)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Invested',
                        style: TextStyle(
                          color: Color(0xff878787),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Obx(() {
                        final totalInvestedAmount =
                            investmentController.selectedInvestment.value ==
                                    "Mutual Fund"
                                ? investmentController.mutualFundInvestment[
                                        'total_invested_amount'] ??
                                    0
                                : stocksController
                                    .stocksInvestment['total_invested_amount'];
                        return Text(
                          formatter.format(totalInvestedAmount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current',
                        style: TextStyle(
                          color: Color(0xff878787),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Obx(() {
                        final totalCurrentValue =
                            investmentController.selectedInvestment.value ==
                                    "Mutual Fund"
                                ? investmentController.mutualFundInvestment[
                                        'total_current_value'] ??
                                    0
                                : stocksController
                                    .stocksInvestment['total_current_value'];
                        return Text(
                          formatter.format(totalCurrentValue),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
