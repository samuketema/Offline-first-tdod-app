part of "task_cubit.dart";

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TaskSuccess extends TaskState {
  final TaskModel task;
  const TaskSuccess(this.task);
}

final class TaskFailure extends TaskState {
  final String message;
  const TaskFailure(this.message);
}
class TaskFetchSuccess extends TaskState {
  final List<TaskModel> tasks;
  TaskFetchSuccess(this.tasks);
}