import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/investment_controller.dart';
import 'package:bobhack/widgets/mutual_fund_tile.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MutualFundsInvestments extends StatelessWidget {
  MutualFundsInvestments({super.key});
  final InvestmentController investmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => investmentController.isLoading.isTrue
        ? const Center(
            child: SpinKitWave(color: primaryColor),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: investmentController.investedMutualFundsList.length,
              itemBuilder: (context, index) {
                var fund = investmentController.investedMutualFundsList[index];
                return InvestedMutualFundTile(
                  fund: fund,
                );
              },
            ),
          ));
  }
}
