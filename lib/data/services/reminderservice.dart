import 'dart:convert';

import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/reminder.dart';

Future<ApiResponse> fetchReminder(int deviceId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(Uri.parse('$reminderDeviceUrl/$deviceId'));

    switch (response.statusCode) {
      case 200:
        List<MedicineReminder> reminders = [];
        for (var reminder in jsonDecode(response.body)['reminder']) {
          reminders.add(MedicineReminder.fromJson(reminder));
        }
        apiResponse.data = reminders;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Reminder not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> fetchNextReminder(int deviceId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(Uri.parse('$reminderNextUrl/$deviceId'));

    switch (response.statusCode) {
      case 200:
        List<MedicineReminder> reminders = [];
        for (var reminder in jsonDecode(response.body)['reminder']) {
          reminders.add(MedicineReminder.fromJson(reminder));
        }
        apiResponse.data = reminders;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Reminder not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> postReminder(MedicineReminder reminder) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(reminderUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reminder.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            MedicineReminder.fromJson(jsonDecode(response.body)['reminder']);
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> putReminder(MedicineReminder reminder) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.put(
      Uri.parse('$reminderUrl/${reminder.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reminder.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            MedicineReminder.fromJson(jsonDecode(response.body)['reminder']);
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Reminder not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> destroyReminder(int id) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.delete(Uri.parse('$reminderUrl/$id'));

    switch (response.statusCode) {
      case 200:
        apiResponse.data = 'Reminder deleted';
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Reminder not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
