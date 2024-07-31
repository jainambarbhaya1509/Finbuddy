import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChart extends StatelessWidget {
  PieChart({super.key});
  final ChartsController chartsController = Get.put(ChartsController());

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() => chartsController.pieChartData.isEmpty
          ? const Center(
              child: Text(
              "No data available",
              style: TextStyle(
                  color: subTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ))
          : DChartPieO(
              configRenderPie: ConfigRenderPie(
                arcWidth: 30,
                arcLabelDecorator: ArcLabelDecorator(
                    labelPosition: ArcLabelPosition.outside,
                    outsideLabelStyle:
                        const LabelStyle(fontSize: 10, color: Colors.white),
                    labelPadding: 0,
                    leaderLineStyle: const ArcLabelLeaderLineStyle(
                        color: Colors.white, length: 15, thickness: 1)),
              ),
              animate: true,
              data: chartsController.pieChartData.map((data) {
                return OrdinalData(
                  domain: data.domain,
                  measure: data.measure,
                  color: Colors.primaries[
                      chartsController.pieChartData.indexOf(data) %
                          Colors.primaries.length],
                );
              }).toList(),
              customLabel: (ordinalData, index) {
                return "${ordinalData.domain}\n₹${ordinalData.measure}";
              },
            )),
    );
  }
}

class LoanPieChart extends StatelessWidget {
  LoanPieChart({super.key});
  final ChartsController chartsController = Get.put(ChartsController());

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() => chartsController.pieChartData.isEmpty
          ? const Center(
              child: Text(
              "No data available",
              style: TextStyle(
                  color: subTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ))
          : DChartPieO(
              configRenderPie: ConfigRenderPie(
                arcWidth: 30,
                arcLabelDecorator: ArcLabelDecorator(
                  labelPosition: ArcLabelPosition.outside,
                  outsideLabelStyle:
                      const LabelStyle(fontSize: 10, color: Colors.white),
                  labelPadding: 0,
                  leaderLineStyle: const ArcLabelLeaderLineStyle(
                      color: Colors.white, length: 15, thickness: 1),
                ),
              ),
              animate: true,
              data: chartsController.loanPieChartData.map((data) {
                return OrdinalData(
                  domain: data.domain,
                  measure: data.measure,
                   color: Colors.primaries[
                      chartsController.loanPieChartData.indexOf(data) %
                          Colors.primaries.length],
                );
              }).toList(),
              customLabel: (ordinalData, index) {
                return "${ordinalData.domain}\n₹${ordinalData.measure}";
              },
            )),
    );
  }
}
