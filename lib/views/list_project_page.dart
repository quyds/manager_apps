import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/models/task_arguments_model.dart';
import 'package:manager_apps/models/project/project_model.dart';
import 'package:manager_apps/models/task/task_model.dart';

import 'widgets/project_list.dart';

class ListProjectPage extends StatefulWidget {
  const ListProjectPage({super.key});

  @override
  State<ListProjectPage> createState() => _ListProjectPageState();
}

class _ListProjectPageState extends State<ListProjectPage> {
  // late List listTask;
  List? _listTasks = [];
  TaskModel? taskModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Project'),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sap xep'),
                    Container(
                      height: 20,
                      // child: DropdownButton<String>(
                      //   // hint: Text('Chọn trạng thái'),
                      //   // value: selectedStateValue,
                      //   elevation: 16,
                      //   style: CustomTextStyle.subOfTextStyle,
                      //   onChanged: (value) {},
                      //   items: ,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
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
                        if (snapshot.data!.docs.length == 0) {
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
                            List _listTasksId = projectModel.taskArray!;

                            for (var e in _listTasksId) {
                              getTaskByProject(e).then((value) {
                                // value.map((item) => {
                                //       _listTasks.add(item.toString()),
                                //     });
                                // TaskModel? taskModel = TaskModel.fromMap(value);
                                print('va ${value.toList()}');
                                return _listTasks?.add(value.toList());
                              });
                            }
                            print(
                                'objecteqweqweqw ${_listTasks!.map((e) => e.toString())}');
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
                                    Container(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            padding: EdgeInsets.all(0)),
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
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _listTasksId.map((e) {
                                        return ListTile(
                                          // onTap: () {
                                          //   getTaskByProject(e);
                                          // },
                                          title: Text(e),
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            )
          ],
        ));
  }

  Future<Iterable<TaskModel>> getTaskByProject(String query) {
    TaskModel? filterProj;
    final result = FirebaseFirestore.instance
        .collection('tasks')
        .where('id', isEqualTo: query)
        .get()
        .then((value) => value.docs.map((e) {
              print('11122 ${e.data()}');
              return filterProj = TaskModel(
                title: e.data()['title'],
                description: e.data()['description'],
              );
            }));
    // return result.the
    // filterProj = result.docs.map((e) {
    //   return e.data();
    // });

    print('filterProj---------- ${result}');

    return result;
  }
}
