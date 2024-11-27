import 'dart:convert';

import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/device.dart';

Future<ApiResponse> getDevice(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse('$deviceUrl/$userId'));

    switch (response.statusCode) {
      case 200:
        Devices device = Devices.fromJson(jsonDecode(response.body));
        apiResponse.data = device;

        final providerDevice = ProviderDevice();
        await providerDevice.open(tableDevices);
        await providerDevice.insert(device);
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
