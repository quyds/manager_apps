import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/data/models/task_arguments_model.dart';
import 'package:manager_apps/presentations/view_models/project/project_model.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';

class ProjectItem extends StatefulWidget {
  final ProjectModel? projectModel;
  final List? listTasksId;
  const ProjectItem({super.key, this.projectModel, this.listTasksId});

  @override
  State<ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.projectModel?.title ?? '',
        style: CustomTextStyle.titleOfTextStyle,
      ),
      subtitle: Text(widget.projectModel?.description ?? '',
          style: CustomTextStyle.subOfTextStyle),
      children: [
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: EdgeInsets.only(
                  left: Dimension.padding.tiny, right: Dimension.padding.tiny)),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(
                  '/CreateTask',
                  arguments: TaskArguments(projectId: widget.projectModel?.id),
                )
                .then(
                  (value) => setState(() {}),
                );
          },
          child: Text(
            'Thêm công việc',
            style: TextStyle(
                fontSize: Dimension.padding.medium, color: Colors.white),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.listTasksId!.map((e) {
            return FutureBuilder(
              future: getTaskById(e),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  return ListTile(
                    title: Text(
                      snapshot.data?.title ?? '',
                      maxLines: 1,
                    ),
                    subtitle: Text(snapshot.data?.state ?? ''),
                  );
                } else {
                  return const Text('No data');
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<TaskModel?> getTaskById(String id) async {
    final doc = FirebaseFirestore.instance.collection("tasks").doc(id);

    final snapShot = await doc.get();

    if (snapShot.exists) {
      return TaskModel.fromMap(snapShot.data()!);
    }
    return null;
  }
}
