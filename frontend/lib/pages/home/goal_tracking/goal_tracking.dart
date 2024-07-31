import 'package:bobhack/constants.dart';
import 'package:bobhack/pages/home/goal_tracking/body.dart';
import 'package:bobhack/pages/home/goal_tracking/header.dart';
import 'package:flutter/material.dart';

class BobGoalTracking extends StatelessWidget {
  const BobGoalTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalsHeader(),
              GoalsBody()
            ],
          ),
        ),
      ),
    );
  }
}
