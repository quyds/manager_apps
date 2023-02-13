part of 'task_list_bloc.dart';

enum TaskListRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class TaskListState {
  const TaskListState({
    this.tasks = const [],
    this.taskStatus = TaskListRequest.unknown,
    this.taskId = const {},
  });

  final List? tasks;
  final TaskListRequest taskStatus;
  final Set<int> taskId;

  TaskListState copyWith({
    List? tasks,
    TaskListRequest? taskStatus,
    Set<int>? taskId,
  }) =>
      TaskListState(
        tasks: tasks ?? this.tasks,
        taskStatus: taskStatus ?? this.taskStatus,
        taskId: taskId ?? this.taskId,
      );
}
