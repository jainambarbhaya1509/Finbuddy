import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentNotifications extends StatelessWidget {
  RecentNotifications({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Recent Notifications",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {},
                    child: const Text("Clear All",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Expanded(
                child: notificationController.notifications.isEmpty
                    ? const Center(
                        child: Text("No Notifications",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      )
                    : ListView.builder(
                        itemCount: notificationController.notifications.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(notificationController
                                .notifications[index].id
                                .toString()),
                            onDismissed: (direction) {
                              notificationController.deleteNotification(
                                  notificationController
                                      .notifications[index].id);
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Notification",
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          const Spacer(),
                                          Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                  DateTime.parse(
                                                      notificationController
                                                          .notifications[index]
                                                          .timestamp)),
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      Text(
                                          notificationController
                                              .notifications[index].content,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: overlayColor,
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
