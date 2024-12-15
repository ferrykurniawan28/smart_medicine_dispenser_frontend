import 'dart:convert';

import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/notification.dart';

Future<ApiResponse> fetchNotification(
    int pageIndex, int perPage, int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(
        Uri.parse('$notificationUrl/$userId?page=$pageIndex&perPage=$perPage'));

    switch (response.statusCode) {
      case 200:
        List<NotificationHistory> notifications = [];
        for (var notification in jsonDecode(response.body)['histories']) {
          notifications.add(NotificationHistory.fromJson(notification));
        }
        apiResponse.data = notifications;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Notification not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
