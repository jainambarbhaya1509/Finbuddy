import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/bot_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FinBuddyBot extends StatelessWidget {
  FinBuddyBot({super.key});

  final FinBuddyBotController finBuddyBotController =
      Get.put(FinBuddyBotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => finBuddyBotController.chatList.isEmpty &&
                        !finBuddyBotController.showGuide.isTrue
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/lottie/chatbot_initial.json",
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Banking Optimization Bot",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "start with `@` for more options",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: finBuddyBotController.chatList.length,
                        itemBuilder: (context, index) {
                          final message = finBuddyBotController.chatList[index];
                          final isUser = message.isUser;

                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              isUser ? 64.0 : 16.0,
                              4,
                              isUser ? 16.0 : 64.0,
                              4,
                            ),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      isUser ? Colors.grey[300] : overlayColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                        color: isUser
                                            ? Colors.black87
                                            : Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Obx(
                  () => finBuddyBotController.showGuide.isTrue
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: // Example of using the dynamic TextButton
                              Column(
                            children: [
                              buildDynamicTextButton("@transaction",
                                  "Chat With Your Bank Account"),
                              buildDynamicTextButton(
                                  "@loans", "Apply for a Loan"),
                              buildDynamicTextButton(
                                  "@investment", "Explore Investment Options"),
                            ],
                          ))
                      : const SizedBox.shrink(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: overlayColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            enableSuggestions: true,
                            maxLines: null,
                            controller: finBuddyBotController.messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ask BOB a question...",
                              hintStyle: TextStyle(color: subTextColor),
                            ),
                            onChanged: (value) {
                              finBuddyBotController.messageController.text
                                      .contains("@")
                                  ? finBuddyBotController.showGuide.value = true
                                  : finBuddyBotController.showGuide.value =
                                      false;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          finBuddyBotController.showGuide.value = false;
                          if (finBuddyBotController
                              .messageController.text.isNotEmpty) {
                            finBuddyBotController.getBotResponse(
                              finBuddyBotController.messageController.text
                                  .trim(),
                            );
                          }
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.paperPlane,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDynamicTextButton(
    String command,
    String description,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        finBuddyBotController.messageController.text = "$command ";
      },
      child: Row(
        children: [
          Text(
            command,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            description,
            style: const TextStyle(color: subTextColor),
          ),
        ],
      ),
    );
  }
}
