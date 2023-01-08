import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/models/task/task_model.dart';

import '../core/extensions/custom_style.dart';
import '../core/extensions/date_format.dart';
import '../core/repositories/list_state.dart';

class ListTaskPage extends StatefulWidget {
  @override
  State<ListTaskPage> createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  var selectedStateValue;
  List filterState = [];

  @override
  void initState() {
    selectedStateValue = list.first;
    filterStateFromFb(list.first);
    super.initState();
  }

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
                  const Text('Trạng thái'),
                  Container(
                    height: 20,
                    child: DropdownButton<String>(
                      // hint: Text('Chọn trạng thái'),
                      value: selectedStateValue,
                      elevation: 16,
                      style: CustomTextStyle.subOfTextStyle,
                      onChanged: (value) {
                        filterStateFromFb(value!);
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
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
                      // if (snapshot.data!.docs.length == 0)
                      if (filterState.length == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Text('No Tasks')],
                        );
                      }
                      print('123 ${filterState.length}');
                      return ListView.builder(
                          itemCount: filterState.length == 0
                              ? snapshot.data!.docs.length
                              : filterState.length,
                          itemBuilder: ((context, index) {
                            TaskModel filterTaskModel =
                                TaskModel.fromMap(filterState[index]);

                            TaskModel taskModel = TaskModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/CreateTask',
                                          arguments: filterState[index]);
                                    },
                                    // leading: Icon(Icons.task),
                                    title: Text(
                                      filterTaskModel.title ??
                                          taskModel.title ??
                                          '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filterTaskModel.description ??
                                                taskModel.description ??
                                                '',
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
                                                Text(
                                                    '${filterTaskModel.state ?? taskModel.state}'),
                                                Text(
                                                    '${getFormatedDate(filterTaskModel.createdAt) ?? getFormatedDate(taskModel.createdAt)}')
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

                      // return ListView.builder(
                      //     itemCount: snapshot.data!.docs.length,
                      //     itemBuilder: ((context, index) {
                      //       TaskModel taskModel = TaskModel.fromMap(
                      //           snapshot.data!.docs[index].data());
                      //       return Container(
                      //         margin: EdgeInsets.all(5),
                      //         child: Card(
                      //           elevation: 5,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: ListTile(
                      //               onTap: () {
                      //                 Navigator.of(context).pushNamed(
                      //                     '/TaskDetail',
                      //                     arguments: taskModel);
                      //               },
                      //               // leading: Icon(Icons.task),
                      //               title: Text(
                      //                 taskModel.title ?? '',
                      //                 style: TextStyle(fontSize: 18),
                      //               ),
                      //               subtitle: Container(
                      //                 margin: EdgeInsets.only(top: 10),
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       taskModel.description ?? '',
                      //                       style: TextStyle(fontSize: 14),
                      //                     ),
                      //                     Container(
                      //                       margin: EdgeInsets.only(top: 10),
                      //                       padding: EdgeInsets.only(top: 5),
                      //                       decoration: BoxDecoration(
                      //                         border: Border(
                      //                           top: BorderSide(
                      //                             color: Colors.grey,
                      //                             width: 1.0,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       child: Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment
                      //                                 .spaceBetween,
                      //                         children: [
                      //                           Text('${taskModel.state}'),
                      //                           Text(
                      //                               '${getFormatedDate(taskModel.createdAt)}')
                      //                         ],
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //               trailing: Icon(
                      //                 Icons.arrow_forward,
                      //                 color: Colors.deepPurple,
                      //                 size: 25,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
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

  void filterStateFromFb(String query) async {
    selectedStateValue = query;
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('state', isEqualTo: query)
        .get();

    print('selectedStateValue ${result.size}');

    setState(() {
      filterState = result.docs.map((e) => e.data()).toList();
      print('filterState ${filterState}');
    });
  }
}
