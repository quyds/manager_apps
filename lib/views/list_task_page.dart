import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_apps/models/task/task_model.dart';
import '../services/data.dart';
import 'widgets/task_item.dart';

class ListTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Task'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(20.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 40.0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trang thai'),
                  Text('In Progress'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey.shade300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .get()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length == 0) {
                        return Text('No Tasks Found');
                      }
                      // return
                      ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            TaskModel taskModel = TaskModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    // onTap: () {
                                    //   Navigator.of(context).pushNamed(
                                    //       '/TaskDetail',
                                    //       arguments: taskModel);
                                    // },
                                    // leading: Icon(Icons.task),
                                    title: Text(
                                      taskModel.title ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            taskModel.description ?? '',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.only(top: 5),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('${taskModel.state}'),
                                                Text('${taskModel.timeStamp}')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.deepPurple,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }));
                    }
                    return Center(
                        // child: CircularProgressIndicator(),
                        );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateTask');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
