import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';
import 'package:manager_apps/presentations/view_models/user/user_model.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc() : super(const ProjectListState()) {
    on<ProjectRequested>(_handleProjectRequested);
  }

  List? filterProject;
  Future<void> _handleProjectRequested(
    ProjectRequested event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          projectStatus: ProjectRequest.requestInProgress,
        ),
      );

      final result = await FirebaseFirestore.instance
          .collection('projects')
          .orderBy('createdAt')
          .get();

      filterProject = result.docs.map((element) => element.data()).toList();

      emit(
        state.copyWith(
          projectStatus: ProjectRequest.requestSuccess,
          projects: filterProject,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          projectStatus: ProjectRequest.requestFailure,
        ),
      );
    }
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = FirebaseFirestore.instance.collection("users").doc(id);

    final snapShot = await doc.get();

    if (snapShot.exists) {
      return UserModel.fromMap(snapShot.data()!);
    }
    return null;
  }

  void showPopupMenu(Offset offset, String? id, BuildContext context) async {
    double left = offset.dx;
    double top = offset.dy;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, top),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text("Chỉnh sửa"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Xóa"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        Navigator.of(context).pushNamed('/FormaaProject');
      }
      if (value == 2) {
        showAlertDialog(context, id);
      }
    });
  }

  showAlertDialog(BuildContext context, id) {
    Widget cancelButton = TextButton(
      child: const Text("Hủy"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Tiếp tục"),
      onPressed: () {
        final docUser =
            FirebaseFirestore.instance.collection('projects').doc(id);
        deleteByProjectId(id);
        docUser.delete();

        const snackBar = SnackBar(
          content: Text(
            'Đã xóa thành công!',
          ),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushNamed('/Main');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Thông báo"),
      content: const Text("Bạn có chắc chắn muốn xóa không?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteByProjectId(String? query) async {
    List? filterState;
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('project', isEqualTo: query)
        .get();

    filterState = result.docs.map((e) => e.data()).map((el) {
      final element = el;
      TaskModel taskModel = TaskModel.fromMap(element);

      final docUser =
          FirebaseFirestore.instance.collection('tasks').doc(taskModel.id);
      docUser.delete();
    }).toList();
  }
}
