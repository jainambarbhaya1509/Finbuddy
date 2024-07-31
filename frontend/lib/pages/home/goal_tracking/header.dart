import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalsHeader extends StatelessWidget {
  GoalsHeader({super.key});
  final GoalController goalController = Get.put(GoalController());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Goal Tracking",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              "Track your financial goals.",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: subTextColor),
            ),
          ],
        ),
        const Spacer(),
        Obx(
          () => goalController.allGoals.isNotEmpty
              ? goalController.toggleAddGoal.isTrue
                  ? TextButton(
                      onPressed: () {
                        goalController.toggleAddGoal.value = false;
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.redAccent),
                      ))
                  : TextButton.icon(
                      onPressed: () {
                        goalController.toggleAddGoal.value = true;
                      },
                      label: const Text(
                        "Add Goal",
                        style: TextStyle(color: primaryColor),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: primaryColor,
                        size: 20,
                      ),
                    )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
