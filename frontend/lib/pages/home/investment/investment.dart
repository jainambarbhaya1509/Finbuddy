import 'package:bobhack/pages/home/investment/mutual_fund_list.dart';
import 'package:flutter/material.dart';
import 'package:bobhack/constants.dart';
import 'package:bobhack/pages/home/investment/explore_funds.dart';

class BobInvestment extends StatelessWidget {
  const BobInvestment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExploreFunds(),
            const SizedBox(height: 10),
            MutualFundsList()
          ],
        ),
      ),
    );
  }
}
