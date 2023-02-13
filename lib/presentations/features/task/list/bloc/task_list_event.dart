part of 'task_list_bloc.dart';

abstract class TaskListEvent {
  const TaskListEvent();
}

class TaskRequested extends TaskListEvent {}
