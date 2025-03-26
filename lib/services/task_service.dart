import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../application.dart';


class TaskService {
  //Get all tasks
  Future<List<dynamic>> getTasks(String sessionToken) async {
    final url = Uri.parse('$baseUrl/classes/task');

    final response = await http.get(
      url,
      headers: {
        "X-Parse-Application-Id": appId,
        "X-Parse-REST-API-Key": apiKey,
        "X-Parse-Session-Token": sessionToken,
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      debugPrint('Failed to load tasks: ${response.body}');
      return [];
    }
  }

  //Create new task
  Future<bool> createTask(
    String sessionToken,
    String title,
    String description,
    String status,
    String userId,
  ) async {
    final url = Uri.parse('$baseUrl/classes/task');

    final payload = {
      "title": title,
      "description": description,
      "status": status,
      "userId": {
        "__type": "Pointer",
        "className": "_User",
        "objectId": userId,
      },
      "ACL": {
        userId: {
          "read": true,
          "write": true
        }
      }
    };

    final response = await http.post(
      url,
      headers: {
        "X-Parse-Application-Id": appId,
        "X-Parse-REST-API-Key": apiKey,
        "X-Parse-Session-Token": sessionToken,
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      debugPrint("Task created successfully: ${response.body}");
      return true;
    } else {
      debugPrint("Failed to create task: ${response.body}");
      return false;
    }
  }
}