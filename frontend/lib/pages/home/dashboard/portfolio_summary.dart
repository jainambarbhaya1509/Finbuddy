import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/summary_controller.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:bobhack/pages/home/dashboard/charts/piechart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PortfolioSummary extends StatelessWidget {
  PortfolioSummary({super.key});

  final InvestmentController investmentController =
      Get.put(InvestmentController());

  final ChartsController chartsController = Get.put(ChartsController());
  final SummaryController summaryController = Get.put(SummaryController());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Portfolio Summary",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const Text(
                "Get a glimps of your portfolio.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: subTextColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        LoanPieChart(),
                        PieChart(),
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
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(
                () => summaryController.loading.isTrue
                    ? const Center(
                        child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SpinKitWaveSpinner(
                            color: primaryColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Eating data for breakfast ",
                            style: TextStyle(
                                color: subTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "May take up to 5 seconds 🤓",
                            style: TextStyle(
                                color: subTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))
                    : Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                    text: "Hello, ",
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text: "${investmentController.name}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor)),
                                const TextSpan(
                                    text: " here's an expert advice for you.",
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(summaryController.profileSummary.value,
                              style: const TextStyle(color: subTextColor)),
                        ],
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
