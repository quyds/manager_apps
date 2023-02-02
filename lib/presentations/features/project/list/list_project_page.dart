import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/presentations/features/project/widgets/project_item.dart';
import 'package:manager_apps/presentations/view_models/project/project_model.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';

class ListProjectPage extends StatefulWidget {
  const ListProjectPage({super.key});

  @override
  State<ListProjectPage> createState() => _ListProjectPageState();
}

class _ListProjectPageState extends State<ListProjectPage> {
  TaskModel? taskModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed('/Main');
            },
          ),
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
                padding: EdgeInsets.all(Dimension.padding.medium),
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
                                ProjectItem(
                                  projectModel: projectModel,
                                  listTasksId: listTasksId,
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
}
