import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/goal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CreateGoal extends StatelessWidget {
  CreateGoal({super.key});
  final GoalController goalController = Get.put(GoalController());
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            width: double.infinity,
            decoration: BoxDecoration(
              color: overlayColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              maxLines: null,
              controller: goalController.createGoalController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: goalController.fetchValidParameters,
                  icon: const FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: subTextColor,
                    size: 20,
                  ),
                ),
                hintText: "Describe Your Goal",
                hintStyle: const TextStyle(color: subTextColor),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => goalController.showValidationField.isTrue
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          child: PageView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Confirm Your Goal",
                                      style: TextStyle(
                                        color: subTextColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Goal Amount",
                                              style: TextStyle(
                                                  color: subTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              width: 150,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: overlayColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                controller: goalController
                                                    .goalAmountController,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                decoration:
                                                    const InputDecoration(
                                                  prefix: Icon(
                                                    Icons
                                                        .currency_rupee_rounded,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Goal Time",
                                              style: TextStyle(
                                                  color: subTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              width: 150,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: overlayColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                controller: goalController
                                                    .goalTimeController,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    const Text(
                                      "Enter Your Monthly Income",
                                      style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: overlayColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: goalController
                                            .monthlyIncomeController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: "Enter your monthly income",
                                          hintStyle:
                                              TextStyle(color: subTextColor),
                                          prefix: Icon(
                                            Icons.currency_rupee_rounded,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Advanced Options",
                                      style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Send My Loan Data",
                                          style: TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              color: subTextColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: primaryColor,
                                          value:
                                              goalController.sendLoanData.value,
                                          onChanged: (value) {
                                            goalController.sendLoanData.value =
                                                value;
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Send My Transaction Data",
                                          style: TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              color: subTextColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: primaryColor,
                                          value: goalController
                                              .sendTransactionData.value,
                                          onChanged: (value) {
                                            goalController.sendTransactionData
                                                .value = value;
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Send My Balance",
                                          style: TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              color: subTextColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: primaryColor,
                                          value: goalController
                                              .sendBalanceData.value,
                                          onChanged: (value) {
                                            goalController
                                                .sendBalanceData.value = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: goalController.fetchSavingsAccountMethod,
                            child: const Text(
                              "Create Summary",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
