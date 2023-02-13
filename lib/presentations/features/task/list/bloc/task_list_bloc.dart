import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(const TaskListState()) {
    on<TaskRequested>(_handleTaskListRequested);
  }

  List? filterFeed;
  Future<void> _handleTaskListRequested(
    TaskRequested event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          taskStatus: TaskListRequest.requestInProgress,
        ),
      );

      final result = await FirebaseFirestore.instance
          .collection('feedItems')
          .orderBy('createdAt')
          .get();

      filterFeed = result.docs.map((element) => element.data()).toList();

      emit(
        state.copyWith(
          taskStatus: TaskListRequest.requestSuccess,
          tasks: filterFeed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          taskStatus: TaskListRequest.requestFailure,
        ),
      );
    }
  }

  Future<List?> getNumTasks(String? query) async {
    List? filterState;
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('state', isEqualTo: query)
        .get();

    filterState = result.docs.map((e) => e.data()).toList();

    return filterState;
  }
}
