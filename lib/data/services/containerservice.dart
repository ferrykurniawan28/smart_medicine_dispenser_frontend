import 'dart:convert';

import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/container.dart';

Future<ApiResponse> updateContainer(
    {required int deviceId,
    required int containerId,
    required String medicine,
    required int quantity}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response =
        await http.put(Uri.parse('$deviceContainerUrl/$deviceId'), body: {
      'container_id': containerId.toString(),
      'medicine_name': medicine,
      'quantity': quantity.toString(),
    });

    switch (response.statusCode) {
      case 200:
        MedicineContainer container = MedicineContainer.fromJson(
            jsonDecode(response.body)['device_content']);
        apiResponse.data = container;
        break;
      case 403:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = 'Container not found';
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
