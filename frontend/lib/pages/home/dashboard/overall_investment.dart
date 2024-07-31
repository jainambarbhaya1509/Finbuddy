import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class OverallInvestment extends StatelessWidget {
  OverallInvestment({super.key});

  final InvestmentController investmentController =
      Get.put(InvestmentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: MediaQuery.sizeOf(context).height * 0.27,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Your Investments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(3),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        const Size(0, 0),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.chartLine,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
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
                      Obx(
                        () => Text(
                          formatter.format(investmentController
                                  .overallInvestment['overall_PL'] ??
                              0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Obx(
                        () => Text(
                          "${investmentController.overallInvestment['overall_PL_percentage'] ?? 0}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Obx(() => investmentController
                                  .overallInvestment['total_invested_amount'] >
                              investmentController
                                  .overallInvestment['total_current_value']
                          ? const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.red, size: 25, weight: 100,)
                          : const Icon(Icons.arrow_drop_up_sharp,
                              color: Colors.green, size: 25, weight: 100,))
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
                          Obx(
                            () => Text(
                              formatter.format(
                                  investmentController.overallInvestment[
                                          'total_invested_amount'] ??
                                      0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
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
                          Obx(
                            () => Text(
                              formatter.format(
                                  investmentController.overallInvestment[
                                          'total_current_value'] ??
                                      0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
