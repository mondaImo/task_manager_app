import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../application.dart';

class AuthService {
  final storage = FlutterSecureStorage();

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

      await storage.write(key: 'sessionToken', value: sessionToken);
      print("Login successfull. Token: $sessionToken");

      return true;
    } else {
      print("Login failed: ${response.body}");
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
      print("Logged out successfully.");
    }
  }

  // get the session token
  Future<String?> getSessionToken() async {
    return await storage.read(key: 'sessionToken');
  }
}