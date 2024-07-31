import 'dart:math';
import 'package:bobhack/constants.dart';
import 'package:bobhack/models/mutual_funds_modal.dart';
import 'package:flutter/material.dart';

int getRandomNumber(int min, int max) {
  final random = Random();
  return min + random.nextInt(max - min + 1);
}

String getRandomImagePath() {
  int randomNumber = getRandomNumber(1, 10);
  return "assets/image$randomNumber.jpg";
}

class MutualFundsTile extends StatelessWidget {
  const MutualFundsTile({super.key, required this.fund});

  final MutualFunds fund;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    getRandomImagePath(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Age: ${fund.age}yr",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Category: ${fund.category}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Size: ${fund.size}cr",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 172, 172, 172),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // Handle investment logic
              },
              child: const Text(
                "Invest",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        const Divider(color: Color.fromARGB(255, 87, 87, 87)),
        const SizedBox(height: 15),
      ],
    );
  }
}

class InvestedMutualFundTile extends StatelessWidget {
  const InvestedMutualFundTile({super.key, required this.fund});

  final InvestedMutualFundModel fund;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    getRandomImagePath(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.fundName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Qty: ${fund.unitsPurchased}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(width: 15),
                      Text(
                        "Invest: ${formatter.format(fund.investmentAmount)}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(width: 15),
                      Text(
                        "Current: ${formatter.format(fund.currentValue).toString()}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Divider(color: Color.fromARGB(255, 87, 87, 87)),
        const SizedBox(height: 15),
      ],
    );
  }
}
