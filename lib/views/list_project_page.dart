import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/const/app_constants.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/models/task_arguments_model.dart';
import 'package:manager_apps/models/project/project_model.dart';
import 'package:manager_apps/models/task/task_model.dart';

class ListProjectPage extends StatefulWidget {
  const ListProjectPage({super.key});

  @override
  State<ListProjectPage> createState() => _ListProjectPageState();
}

class _ListProjectPageState extends State<ListProjectPage> {
  // late List listTask;
  TaskModel? taskModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách dự án'),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimension.padding.medium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Sắp xếp'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade300,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects')
                        .get()
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [Text('No Tasks')],
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            ProjectModel? projectModel = ProjectModel.fromMap(
                                snapshot.data!.docs[index].data());
                            List listTasksId = projectModel.taskArray!;

                            return Column(
                              children: <Widget>[
                                ExpansionTile(
                                  title: Text(
                                    projectModel.title ?? '',
                                    style: CustomTextStyle.titleOfTextStyle,
                                  ),
                                  subtitle: Text(projectModel.description ?? '',
                                      style: CustomTextStyle.subOfTextStyle),
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          padding: EdgeInsets.only(
                                              left: Dimension.padding.tiny,
                                              right: Dimension.padding.tiny)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(
                                              '/CreateTask',
                                              arguments: TaskArguments(
                                                  projectId: projectModel.id),
                                            )
                                            .then(
                                              (value) => setState(() {}),
                                            );
                                      },
                                      child: Text(
                                        'Thêm công việc',
                                        style: TextStyle(
                                            fontSize: Dimension.padding.medium,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: listTasksId.map((e) {
                                        return FutureBuilder(
                                          future: getTaskById(e),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            }
                                            if (snapshot.hasData) {
                                              return ListTile(
                                                title: Text(
                                                  snapshot.data?.title ?? '',
                                                  maxLines: 1,
                                                ),
                                                subtitle: Text(
                                                    snapshot.data?.state ?? ''),
                                              );
                                            } else {
                                              return const Text('No data');
                                            }
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            )
          ],
        ));
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
