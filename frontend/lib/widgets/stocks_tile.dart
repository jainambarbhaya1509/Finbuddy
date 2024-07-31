import 'package:bobhack/constants.dart';
import 'package:bobhack/models/stocks_model.dart';
import 'package:flutter/material.dart';

class StocksTile extends StatelessWidget {
  const StocksTile({super.key, required this.stocks});

  final StocksModel stocks;

  @override
  Widget build(BuildContext context) {
    final double purchasedPrice = double.parse(stocks.purchasedPrice);
    final double quantity = stocks.quantity.toDouble();
    final double invested = purchasedPrice * quantity;
    final double? currentPrice = stocks.currentPrice;

    // Check if currentPrice is null to avoid calculations with null values
    final double ltp =
        currentPrice != null ? (currentPrice - purchasedPrice) * quantity: 0.0;
    final double percentageChange = currentPrice != null
        ? ((currentPrice - purchasedPrice) / purchasedPrice) * 100
        : 0.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      color: overlayColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                "Qty.",
                style: TextStyle(color: subTextColor, fontSize: 15),
              ),
              const SizedBox(width: 5),
              Text(
                stocks.quantity.toString(),
                style: const TextStyle(color: Colors.white38, fontSize: 15),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.circle,
                color: subTextColor,
                size: 7,
              ),
              const SizedBox(width: 10),
              const Text(
                "Avg.",
                style: TextStyle(color: subTextColor, fontSize: 15),
              ),
              const SizedBox(width: 5),
              Text(
                stocks.purchasedPrice,
                style: const TextStyle(color: Colors.white38, fontSize: 15),
              ),
              const Spacer(),
              Text(
                "${percentageChange.toStringAsFixed(2)}%",
                style: TextStyle(
                    color:
                        percentageChange < 0 ? Colors.redAccent : Colors.green,
                    fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                stocks.stockName,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              const Spacer(),
              Text(
                ltp.toStringAsFixed(2),
                style: TextStyle(
                    color: ltp < 0 ? Colors.redAccent : Colors.green,
                    fontSize: 17),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Invested",
                style: TextStyle(color: subTextColor, fontSize: 15),
              ),
              const SizedBox(width: 5),
              Text(
                invested.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white38, fontSize: 15),
              ),
              const Spacer(),
              const Text(
                "Current",
                style: TextStyle(color: subTextColor, fontSize: 15),
              ),
              const SizedBox(width: 5),
              Text(
                currentPrice != null ? currentPrice.toStringAsFixed(2) : "0.0",
                style: const TextStyle(color: Colors.white38, fontSize: 15),
              ),
              const SizedBox(width: 5),
              Text(
                "${percentageChange.toStringAsFixed(2)}%",
                style: TextStyle(
                    color:
                        percentageChange < 0 ? Colors.redAccent : Colors.green,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
