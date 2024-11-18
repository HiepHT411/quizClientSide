
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizflutter/constants/api_endpoints.dart';
import 'package:quizflutter/models/authentication_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  String accessToken = '';
  final String accTokenKey = 'accessToken';

  Future<void> saveAccessToken(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accTokenKey, token);
    await prefs.setString("email", email);
  }

  Future<String> get getAccessToken async {
    if (accessToken.isEmpty) {
      await loadAccessToken();
    }
    log(accessToken);
    return accessToken;
  }

  Future<void> loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(accTokenKey);
    if (token != null) {
      accessToken = token;
    }
  }

  Future<bool> checkSession() async {
    if (accessToken.isNotEmpty) {
      return true;
    } else {
      await loadAccessToken();
      return accessToken.isNotEmpty;
    }
  }

  Future<AuthenticationResult> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_URL${ApiEndpoint.loginEndpoint}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>  {
        'email': email,
        'password': password
      })
    );

    log("login: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['accessToken'];
      accessToken = token;

      await saveAccessToken(accessToken, email);
      return AuthenticationResult(success: true);
    } else if (response.statusCode == 403) {
      return AuthenticationResult(success: false, errorMessage: "Your account might has not been enabled");
    } else {
      const errMsg = 'Authentication failed. Your email or password might incorrect';
      return AuthenticationResult(success: false, errorMessage: errMsg);
    }
  }

  Future<AuthenticationResult> signup(String username, String email, String password) async{
    final response = await http.post(
      Uri.parse('$API_URL${ApiEndpoint.signupEndpoint}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String> {
        'email': email,
        'username': username,
        'password': password
      })
    );

    log('signup: ${response.statusCode}');

    if (response.statusCode == 201) {
      return AuthenticationResult(success: true, errorMessage: 'Signup Success');
    } else {
      final errJson = jsonDecode(response.body);
      final errMsg = errJson['message'] ?? 'Registration failed';
      return AuthenticationResult(success: false, errorMessage: errMsg);
    }
  }
}