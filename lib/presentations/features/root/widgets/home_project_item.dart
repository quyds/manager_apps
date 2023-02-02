import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/core/extensions/date_format.dart';
import 'package:manager_apps/core/repositories/list_state.dart';
import 'package:manager_apps/presentations/view_models/project/project_model.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';
import 'package:manager_apps/presentations/view_models/user/user_model.dart';

class HomeProjectItem extends StatefulWidget {
  final ProjectModel? projectModel;
  final List? toListUsers;
  final int? toIndex;
  final List? toFilterState;
  const HomeProjectItem(
      {super.key,
      this.projectModel,
      this.toListUsers,
      this.toIndex,
      this.toFilterState});

  @override
  State<HomeProjectItem> createState() => _HomeProjectItemState();
}

class _HomeProjectItemState extends State<HomeProjectItem> {
  late int? index = widget.toIndex;
  late List? filterState = widget.toFilterState;
  late List? listUsers = widget.toListUsers;
  late int? projectEmployeeLength = widget.projectModel?.employeeArray?.length;
  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/ListProject');
        },
        onDoubleTap: () {
          _showPopupMenu(Offset(120, 250), widget.projectModel?.id);
        },
        // onDoubleTapDown: (TapDownDetails details) {
        //   _showPopupMenu(details.globalPosition, projectModel.id);
        // },
        child: Container(
          padding: EdgeInsets.only(
              left: Dimension.padding.small, right: Dimension.padding.small),
          margin: EdgeInsets.only(right: Dimension.padding.small),
          height: screenSizeWidth < 600
              ? screenSizeWidth / 2.5
              : screenSizeWidth / 5,
          width: screenSizeWidth < 600
              ? screenSizeWidth / 2.5
              : screenSizeWidth / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimension.radius.gigantic),
            color: colors[index!],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${widget.projectModel?.taskArray!.length} Công việc',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                widget.projectModel?.title ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Tháng ${getFormatedMonthYear(widget.projectModel?.createdAt)}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              listUsers!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: listUsers!.map((e) {
                            return FutureBuilder(
                              future: getUserById(e),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                if (snapshot.hasData) {
                                  String? image = snapshot.data?.profileImage;
                                  return Container(
                                    width: 25,
                                    height: 25,
                                    margin: EdgeInsets.only(
                                        left: Dimension.padding.tiny,
                                        right: Dimension.padding.tiny),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: image == null
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/avatar.png'),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: NetworkImage(image),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        ),
                        projectEmployeeLength! > 3
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '+${projectEmployeeLength! - 3} ',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                ],
                              )
                            : Row(),
                      ],
                    )
                  : Row(),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = FirebaseFirestore.instance.collection("users").doc(id);

    final snapShot = await doc.get();

    if (snapShot.exists) {
      return UserModel.fromMap(snapShot.data()!);
    }
    return null;
  }

  void _showPopupMenu(Offset offset, String? id) async {
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
        Navigator.of(context).pushNamed('/FormaaProject').then((value) {
          setState(() {});
        });
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
