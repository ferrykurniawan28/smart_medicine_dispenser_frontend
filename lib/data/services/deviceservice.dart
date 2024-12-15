import 'dart:convert';

import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/device.dart';

Future<ApiResponse> getDevice(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(Uri.parse('$deviceUserUrl/$userId'));

    switch (response.statusCode) {
      case 200:
        Devices device =
            Devices.fromJson(jsonDecode(response.body)['devices'][0]);
        // print(device);
        apiResponse.data = device;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Device not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> registerDevice(String uid, int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response =
        await http.post(Uri.parse('$deviceUrl/$uid/register-user'), body: {
      'user_id': userId.toString(),
    });

    switch (response.statusCode) {
      case 200:
        Devices device = Devices.fromJson(jsonDecode(response.body)['device']);
        apiResponse.data = device;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Device not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> fetchDeviceTemperature(String deviceId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response =
        await http.get(Uri.parse('$deviceTemperatureUrl/$deviceId'));

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['temperature'];
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Device not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> updateDeviceTemperature(
    String deviceId, int temperature) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response =
        await http.put(Uri.parse('$deviceTemperatureUrl/$deviceId'), body: {
      'temperature': temperature.toString(),
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['device'];
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Device not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> updateDeviceState(int state, int deviceId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response =
        await http.post(Uri.parse('$deviceStateUrl/$deviceId'), body: {
      'current_state': state.toString(),
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['device'];
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Device not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
