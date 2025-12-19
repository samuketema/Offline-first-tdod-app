import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/core/constants/utils.dart';
import 'package:taskapp/features/auth/home/repositories/task_remote_repository.dart';
import 'package:taskapp/models/task_model.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());
  final repository = TaskRemoteRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(TaskLoading());

      final task = await repository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );

      emit(TaskSuccess(task));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> getTask({required String token}) async {
    try {
      emit(TaskLoading());

      final tasks = await repository.getTask(token: token);

      emit(TaskFetchSuccess(tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
}
