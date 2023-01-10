import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:manager_apps/models/project/project_model.dart';
import 'package:manager_apps/models/task/task_model.dart';

import 'widgets/project_list.dart';

class ListProjectPage extends StatefulWidget {
  const ListProjectPage({super.key});

  @override
  State<ListProjectPage> createState() => _ListProjectPageState();
}

class _ListProjectPageState extends State<ListProjectPage> {
  List filterProj = [];
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

                            print('object ${snapshot.data!.docs}');
                            return Column(
                              children: <Widget>[
                                ExpansionTile(
                                  title: Text(projectModel.title ?? ''),
                                  subtitle:
                                      Text(projectModel.description ?? ''),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          projectModel.taskArray!.map((e) {
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('tasks')
                                              .where('id', isEqualTo: e)
                                              .get()
                                              .asStream(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            }
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  TaskModel filterTaskModel =
                                                      TaskModel.fromMap(snapshot
                                                          .data!.docs[index]
                                                          .data());
                                                  return Center();
                                                },
                                              );
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        );
                                        return ListTile(
                                          onTap: () {
                                            searchTaskByProject(e);
                                          },
                                          title: Text(e),
                                        );
                                      }).toList(),
                                    )
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

  searchTaskByProject(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('id', isEqualTo: query)
        .get();

    // query(collection(db, "cities"), where("capital", "==", true));
    setState(() {
      filterProj = result.docs.map((e) => e.data()).toList();
      print('filterProj ${filterProj}');
    });
    return ListTile(
      title: Text('s'),
    );
  }
}
