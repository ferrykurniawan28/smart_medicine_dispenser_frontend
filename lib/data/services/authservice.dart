import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dispencer/data/constants/constants.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dispencer/data/models/user.dart';

// login user
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginUrl), body: {
      'email': email,
      'password': password,
    });

    print(response.body);
    print(response.statusCode);

    switch (response.statusCode) {
      case 200:
        getToken(jsonDecode(response.body)['token']);
        saveUserId(jsonDecode(response.body)['user']['id']);
        String token = jsonDecode(response.body)['token'];
        User newUser = User.fromJson(jsonDecode(response.body)['user']);
        newUser.token = token;

        final providerUser = ProviderUser();
        await providerUser.open(tableUser);
        await providerUser.insertOrUpdate(newUser);
        apiResponse.data = newUser;
        // apiResponse.data = User.fromJson(jsonDecode(response.body)['user']);
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
    print(e);
  }

  return apiResponse;
}

// login user with user id
Future<ApiResponse> loginWithId(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse('$loginUrl/id'), body: {
      'id': userId.toString(),
    });

    switch (response.statusCode) {
      case 200:
        getToken(jsonDecode(response.body)['token']);
        saveUserId(jsonDecode(response.body)['user']['id']);
        apiResponse.data = User.fromJson(jsonDecode(response.body)['user']);
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

// register user
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerUrl), body: {
      'name': name,
      'email': email,
      'password': password,
      'role': 'user',
    });

    switch (response.statusCode) {
      case 200:
        getToken(jsonDecode(response.body)['token']);
        saveUserId(jsonDecode(response.body)['user']['id']);
        String token = jsonDecode(response.body)['token'];
        User newUser = User.fromJson(jsonDecode(response.body)['user']);
        newUser.token = token;

        final providerUser = ProviderUser();
        await providerUser.open(tableUser);
        await providerUser.insertOrUpdate(newUser);
        apiResponse.data = newUser;
        // apiResponse.data = User.fromJson(jsonDecode(response.body)['user']);
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
