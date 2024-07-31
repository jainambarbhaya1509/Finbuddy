import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/transaction_controller.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarChart extends StatelessWidget {
  BarChart({super.key});
  final ChartsController chartsController = Get.put(ChartsController());

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() => chartsController.barChartData.isEmpty
          ? const Center(
              child: Text(
              "No data available",
              style: TextStyle(
                  color: subTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ))
          : DChartBarCustom(
              measureLabelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              domainLabelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              showDomainLabel: true,
              showDomainLine: true,
              showLoading: true,
              showMeasureLabel: true,
              showMeasureLine: true,
              spaceDomainLinetoChart: 10,
              spaceBetweenItem: 10,
              spaceDomainLabeltoChart: 10,
              spaceMeasureLabeltoChart: 10,
              spaceMeasureLinetoChart: 10,
              radiusBar: BorderRadius.circular(10),
              domainLineStyle: const BorderSide(color: Colors.white, width: 1),
              measureLineStyle: const BorderSide(color: Colors.white, width: 1),
              valuePadding: const EdgeInsets.all(20),
              verticalDirection: true,
              listData: chartsController.barChartData.map((data) {
                return DChartBarDataCustom(
                  value: data.value,
                  label: data.label,
                  color: primaryColor,
                );
              }).toList(),
            )),
    );
  }
}
