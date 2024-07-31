import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/controllers/stocks_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ExploreFunds extends StatelessWidget {
  ExploreFunds({super.key});

  final MutualFundsController mutualFundsController =
      Get.put(MutualFundsController());

  final InvestmentController investmentController = Get.find();
  final StocksController stocksController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  "Explore top funds",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: subTextColor),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.all(3),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () {
                investmentController.getInvestedMutualFunds();
                stocksController.getInvestedStocks();
              },
              child: const Text(
                "Your Funds",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10),
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() => TextFormField(
                    controller:
                        mutualFundsController.mutualFundSearchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      hintText: mutualFundsController.searchType.value == 'amc'
                          ? "Search 3000+ Mutual Funds"
                          : '"Mutual funds for retirement"',
                      hintStyle: const TextStyle(
                        color: subTextColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: mutualFundsController.toggleSearchType,
                        icon: const FaIcon(
                          FontAwesomeIcons.rightLeft,
                          color: subTextColor,
                          size: 20,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: subTextColor,
                        size: 20,
                      ),
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (value) {
                      if (mutualFundsController.searchType.value == 'genai') {
                        mutualFundsController.fetchMutualFundsWithGenAI();
                      } else {
                        mutualFundsController.searchMutualFunds(value);
                      }
                    },
                  )),
            ),
            Obx(
              () => mutualFundsController.searchType.value == 'genai'
                  ? mutualFundsController.mutualFunds.isEmpty
                      ? const SizedBox.shrink()
                      : mutualFundsController.mutualFundInfoMessage.isNotEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    const Text(
                                      "Risk: ",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      mutualFundsController.risk.value,
                                      style: const TextStyle(
                                          color: subTextColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    const Text(
                                      "Invest: ",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      mutualFundsController.term.value,
                                      style: const TextStyle(
                                          color: subTextColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    const Text(
                                      "Return: ",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      mutualFundsController.returns.value,
                                      style: const TextStyle(
                                          color: subTextColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ],
    );
  }
}
