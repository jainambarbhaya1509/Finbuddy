import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/stocks_controller.dart';
import 'package:bobhack/widgets/stocks_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StocksInvestment extends StatelessWidget {
  StocksInvestment({super.key});

  final StocksController stocksController = Get.put(StocksController());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: stocksController.investedStocks.length,
        itemBuilder: (context, index) {
          var stocks = stocksController.investedStocks[index];
          return InkWell(
            onTap: () {
              stocksController.fetchInvestedStockNews(
                  stocks.stockName, stocks.id);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(
                            () => stocksController.isLoadingAnalysis.isTrue &&
                                    stocksController.isLoadingNews.isTrue
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
                                      Expanded(
                                        child: PageView(
                                          controller: _pageController,
                                          children: [
                                            Column(
                                              children: [
                                                Obx(
                                                  () => Text(
                                                    stocksController.stockNews[
                                                            "title"] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    stocksController.stockNews[
                                                            "description"] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        height: 1.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Obx(
                                              () => Text(
                                                stocksController
                                                    .stockAnalyis.value,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: subTextColor,
                                                    height: 1.5),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Page indicator
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SmoothPageIndicator(
                                          controller: _pageController,
                                          count:
                                              2, // Number of pages in your PageView
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
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          )),
                    );
                  });
            },
            child: StocksTile(
              stocks: stocks,
            ),
          );
        },
      ),
    );
  }
}
