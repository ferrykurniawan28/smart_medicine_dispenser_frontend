import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginUrl), body: {
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        getToken(jsonDecode(response.body)['token']);
        saveUserId(jsonDecode(response.body)['user']['id']);
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = jsonDecode(response.body);
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

// get user token
Future<String> getToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(token) ?? '';
}

// save user id
Future<void> saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('userId', userId);
}
