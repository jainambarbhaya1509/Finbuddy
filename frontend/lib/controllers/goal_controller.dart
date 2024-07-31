import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/models/goals_model.dart';
import 'package:bobhack/pages/home/goal_tracking/goal_map.dart';
import 'package:bobhack/pages/home/goal_tracking/summary.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoalController extends GetxController {
  RxBool toggleAddGoal = false.obs;
  final TextEditingController createGoalController = TextEditingController();
  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController goalTimeController = TextEditingController();
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController savedAmountController = TextEditingController();

  final goalAmount = 0.0.obs;
  final goalName = ''.obs;
  final goalTime = 0.obs;
  RxBool sendLoanData = true.obs;
  RxBool sendTransactionData = true.obs;
  RxBool sendBalanceData = true.obs;
  RxBool showValidationField = false.obs;
  var selectedInvestmentStrategy = ''.obs;

  // Savings Account
  final TextEditingController monthlyIncomeController = TextEditingController();
  var monthlyIncome = 0.obs;

  RxBool processingCompleted = false.obs;

  // Send Data To Summary
  RxMap<String, dynamic> goalData = <String, dynamic>{}.obs;

  @override
  void onClose() {
    createGoalController.dispose();
    goalAmountController.dispose();
    goalTimeController.dispose();
    monthlyIncomeController.dispose();
    super.onClose();
  }

  void changeSelectedInvestmentStrategy(String newInvestmentStrategy) {
    selectedInvestmentStrategy.value = newInvestmentStrategy;
  }

  void fetchValidParameters() {
    Dio()
        .get(
      "$baseUrl/api/goalTrack/inputAnalyse/${createGoalController.text}",
      options: Options(headers: {
        "userauth": Get.find<LoginController>().sessionToken,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (data.containsKey("goal_amount") &&
              data.containsKey("time_frame")) {
            goalAmountController.text = data["goal_amount"].toString();
            goalTimeController.text = data["time_frame"].toString();
            goalNameController.text = data["goal_name"].toString();
            showValidationField.value = true;
          } else {
            Get.snackbar(
                "Error", "Received data does not contain the expected keys");
          }
        } else {
          Get.snackbar("Error", "Received null or invalid data from server");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch valid parameters");
      }
    }).catchError((error) {
      Get.snackbar(
          "Error", "An error occurred while fetching valid parameters");
    });
  }

  // Savings Account
  void fetchSavingsAccountMethod() {
    if (monthlyIncomeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your monthly income");
      return;
    }

    goalAmount.value = double.tryParse(goalAmountController.text) ?? 0.0;
    goalTime.value = int.tryParse(goalTimeController.text) ?? 0;
    monthlyIncome.value = int.tryParse(monthlyIncomeController.text) ?? 0;
    goalName.value = goalNameController.text;

    if (goalAmount.value == 0.0 ||
        goalTime.value == 0 ||
        goalAmountController.text.isEmpty ||
        goalTimeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a valid goal amount and time frame");
      return;
    }

    Dio().post(
      "$baseUrl/api/goalTrack/saveMethod",
      options: Options(
        headers: {"userauth": Get.find<LoginController>().sessionToken},
      ),
      data: {
        "goal_amount": goalAmount.value,
        "time_frame": goalTime.value,
        "month_income": monthlyIncome.value,
        "loan": sendLoanData.value,
        "transaction": sendTransactionData.value,
        "balance": sendBalanceData.value,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          int tiles;
          if (data["time_frame"] > 30) {
            tiles = data["time_frame"] ~/ 30;
          } else {
            tiles = data["time_frame"];
          }
          goalData.value = data;
          processingCompleted.value = true;
          Get.to(() => Summary(), arguments: goalData);
        } else {
          Get.snackbar(
              "Error", "Response data is null or not in expected format.");
        }
      } else if (response.statusCode == 404) {
        Get.snackbar(
            "Error", "Please enter a valid goal amount and time frame");
      } else {}
    }).catchError((error) {});
  }

  void addGoal() {
    Dio().post("$baseUrl/api/goalTrack/addGoalData",
        options: Options(headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        }),
        data: {
          "goal_amount": goalData["goal_amount"],
          "time_frame": goalData["time_frame"],
          "saving_needed": goalData["saving_needed_excluding_all"],
          "interval": goalData["interval"],
          "name": goalName.value,
        }).then((response) {
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Goal added successfully");
        toggleAddGoal.value = false;
        getAllGoals();
        getGoalMap(response.data["goal_id"]);
      } else {
        Get.snackbar("Error", "Failed to add goal");
      }
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred while adding goal");
    });
  }

// List Of All Goals
  RxList<Goal> allGoals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllGoals();
  }

  void getAllGoals() {
    Dio()
        .get(
      "$baseUrl/api/goalTrack/getGoals",
      options: Options(
        headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null && data is List<dynamic>) {
          try {
            for (var item in data) {
              DateTime targetDate = DateTime.parse(item['target_date']);
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(targetDate);
              Goal goal = Goal(
                id: item['id'] as int,
                goalAmount: item['goal_amount'],
                name: item['name'] as String,
                targetDate: formattedDate,
              );
              allGoals.add(goal);
              allGoals.refresh();
            }
          } catch (e) {
            Get.snackbar("Error", "Failed to parse goals data: $e");
          }
        } else {
          Get.snackbar("Error", "Received null or invalid data from server");
        }
      } else {
        Get.snackbar("Error",
            "Failed to fetch goals with status code: ${response.statusCode}");
      }
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred: $error");
    });
  }

// Individual Goal Data Month Wise
  var individualGoalData = {}.obs;
  void getGoalMap(int goalId) {
    Dio()
        .get("$baseUrl/api/goalTrack/getGoalMap/$goalId",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
        individualGoalData.value = data;

        if (data != null) {
        } else {
          Get.snackbar("Error", "Received null or invalid data from server");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch goal map");
      }
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred while fetching goal map");
    }).whenComplete(() {
      Get.back();
      Get.to(() => GoalMap(),
          arguments: individualGoalData, curve: Curves.easeInOut);
    });
  }

  void updateGoal(String savedAmount) {
    Dio().post("$baseUrl/api/goalTrack/updateGoal",
        options: Options(headers: {
          "userauth": Get.find<LoginController>().sessionToken,
        }),
        data: {
          "goal_id": individualGoalData["goal"]["id"],
          "saved_amount": savedAmount,
          "goal_amount": individualGoalData["goal"]["goal_amount"],
          "pending_amount": individualGoalData["pending_amount"],
          "time_frame": individualGoalData["goal"]["time_frame"],
          "interval": individualGoalData["goal"]["interval"],
        }).then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (data["pending_amount"] == "0" && data["saving_needed"] == "0") {
            Get.snackbar("Success", "Goal completed successfully");
            return;
          }
          individualGoalData["goal"]["pending_amount"] = data["pending_amount"];
          individualGoalData["goal"]["savings_needed"] = data["saving_needed"];
          individualGoalData.refresh();

          getGoalMap(individualGoalData["goal"]["id"]);
        } else {
          Get.snackbar("Error", "Received null or invalid data from server");
        }
      } else {
        Get.snackbar("Error", "Failed to update goal");
      }
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred while updating goal");
    });
  }

  void deleteGoal(int goalId) {
    Dio()
        .delete("$baseUrl/api/goalTrack/deleteGoal/$goalId",
            options: Options(headers: {
              "userauth": Get.find<LoginController>().sessionToken,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Goal deleted successfully",
            colorText: Colors.white);
        allGoals.removeWhere((element) => element.id == goalId);
        allGoals.refresh();
      } else {
        Get.snackbar("Error", "Failed to delete goal", colorText: Colors.white);
      }
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred while deleting goal",
          colorText: Colors.white);
    });
  }
}
