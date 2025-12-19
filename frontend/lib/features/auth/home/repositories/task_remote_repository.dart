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
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUrl}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // verify backend expects this
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return TaskModel.fromJson(res.body);
    } catch (e) {
      rethrow;
    }
  }

 Future<List<TaskModel>> getTask({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUrl}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // verify backend expects this
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      final listOfTasks = jsonDecode(res.body);

      List<TaskModel> taskList = [];

      for(var elem in listOfTasks){
        taskList.add(TaskModel.fromMap(elem));
      }
      return taskList;
    } catch (e) {
      rethrow;
    }
  }
}
