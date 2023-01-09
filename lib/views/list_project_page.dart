import 'package:cloud_firestore/cloud_firestore.dart';
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
                              return Column(
                                children: <Widget>[
                                  ExpansionTile(
                                    title: Text(projectModel.title ?? ''),
                                    subtitle:
                                        Text(projectModel.description ?? ''),
                                    children: [
                                      ListTile(
                                        title: Text(
                                            '11 ${projectModel.taskArray![index]}'),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }));
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
}
