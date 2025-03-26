import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../application.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  // Signup method
  Future<bool> signUp(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');

    final response = await http.post(
      url,
      headers: {
        "X-Parse-Application-Id": appId,
        "X-Parse-REST-API-Key": apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email
      }),
    );

    if(response.statusCode == 201) {
      debugPrint("Signup successful: ${response.body}");
      return true;
    } else {
      debugPrint("Signup failed: ${response.body}");
      return false;
    }
  }

  // Login method
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        "X-Parse-Application-Id": appId,
        "X-Parse-REST-API-Key": apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password
      }),
    );

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sessionToken = data['sessionToken'];
      final userId = data['objectId'];

      await storage.write(key: 'sessionToken', value: sessionToken);
      await storage.write(key: 'userId', value: userId);
      debugPrint("Login successfull. Token: $sessionToken, useId: $userId");

      return true;
    } else {
      debugPrint("Login failed: ${response.body}");
      return false;
    }
  }

  //Logout method
  Future<void> logout() async {
    final token = await storage.read(key: 'sessionToken');

    if (token != null) {
      final url = Uri.parse('$baseUrl/logout');

      await http.post(
        url,
        headers: {
          "X-Parse-Application-Id": appId,
          "X-Parse-REST-API-Key": apiKey,
          "X-Parse-Session-Token": token,
        },
      );

      await storage.delete(key: 'sessionToken');
      debugPrint("Logged out successfully.");
    }
  }

  // get the session token
  Future<String?> getSessionToken() async {
    return await storage.read(key: 'sessionToken');
  }
}