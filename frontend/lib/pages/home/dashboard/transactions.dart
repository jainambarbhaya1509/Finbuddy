import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:bobhack/pages/home/dashboard/charts/barchart.dart';
import 'package:bobhack/pages/home/dashboard/charts/piechart.dart';
import 'package:bobhack/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecentTransactions extends StatelessWidget {
  RecentTransactions({super.key});

  final TransactionController transactionController = Get.find();
  final ChartsController chartsController = Get.find();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: chartsController.toggleplot.toggle,
                    icon: Obx(
                      () => FaIcon(
                        chartsController.toggleplot.isTrue
                            ? FontAwesomeIcons.moneyBills
                            : FontAwesomeIcons.chartSimple,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              return chartsController.toggleplot.isTrue
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          child: PageView(
                            controller: _pageController,
                            children: [
                              PieChart(),
                              BarChart(),
                            ],
                          ),
                        ),
                        // Page indicator
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 2, // Number of pages in your PageView
                            effect: const WormEffect(
                              dotWidth: 10.0,
                              dotHeight: 10.0,
                              spacing: 16.0,
                              radius: 8.0,
                              dotColor: Colors.grey,
                              activeDotColor: primaryColor,
                            ),
                            onDotClicked: (index) {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            }),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: transactionController.transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactionController.transactions[index];
                    return TransactionTile(transaction: transaction);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
