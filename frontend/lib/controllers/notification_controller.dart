import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/login_controller.dart';
import 'package:bobhack/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxList<Notifications> notifications = <Notifications>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    Dio()
        .get("$baseUrl/api/notifications/read",
            options: Options(
              headers: {
                "userauth": Get.find<LoginController>().sessionToken,
              },
            ))
        .then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        notifications.value = data.map((item) {
          return Notifications(
            id: item['id'],
            accountId: item['account_id'],
            content: item['content'],
            timestamp: item['timestamp'],
            isRead: item['is_read'],
          );
        }).toList();
        notifications.refresh();
      }
    }).catchError((error) {
    }).onError((error, stackTrace) {
    });
  }

  void deleteNotification(int id) {
    Dio()
        .get("$baseUrl/api/notifications/delete/$id",
            options: Options(
              headers: {
                "userauth": Get.find<LoginController>().sessionToken,
              },
            ))
        .then((response) {
      if (response.statusCode == 200) {
        notifications.removeWhere((notification) => notification.id == id);
      }
    }).catchError((error) {
    }).onError((error, stackTrace) {
    });
  }
}
