import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskapp/core/constants/constants.dart';
import 'package:taskapp/models/task_model.dart';

class TaskRemoteRepository {
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueAt,
    required String token,
  }) async {
    final res = await http.post(
      Uri.parse("${Constants.backendUrl}/tasks"),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token, // verify backend expects this
      },
      body: jsonEncode({
        'title': title,
        'describtion': description,
        'hexColor': hexColor,
        'dueAt': dueAt.toIso8601String(),
      }),
    );

    // 🔍 DEBUG PRINT (VERY IMPORTANT)
    print('STATUS CODE: ${res.statusCode}');
    print('RESPONSE BODY: ${res.body}');

    if (res.statusCode != 201) {
      final error = jsonDecode(res.body);
      throw error['error'] ?? 'Something went wrong';
    }

    final data = jsonDecode(res.body);
    return TaskModel.fromJson(data);
  }
}
