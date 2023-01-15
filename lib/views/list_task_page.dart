import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/models/task_arguments_model.dart';
import 'package:manager_apps/models/task/task_model.dart';

import '../core/extensions/custom_style.dart';
import '../core/extensions/date_format.dart';
import '../core/repositories/list_state.dart';

class ListTaskPage extends StatefulWidget {
  final String? currentState;
  const ListTaskPage({super.key, this.currentState});

  @override
  State<ListTaskPage> createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  var selectedStateValue;
  List filterState = [];

  @override
  void initState() {
    if (widget.currentState != null) {
      selectedStateValue = widget.currentState;
      filterStateFromFb(widget.currentState);
    } else {
      selectedStateValue = list.first;
      filterStateFromFb(list.first);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
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
                  const Text('Trạng thái'),
                  SizedBox(
                    height: 30,
                    child: DropdownButton<String>(
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
                      if (filterState.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Text('No Tasks')],
                        );
                      }
                      return ListView.builder(
                          itemCount: filterState.isEmpty
                              ? snapshot.data!.docs.length
                              : filterState.length,
                          itemBuilder: ((context, index) {
                            TaskModel filterTaskModel =
                                TaskModel.fromMap(filterState[index]);

                            TaskModel taskModel = TaskModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/CreateTask',
                                              arguments: TaskArguments(
                                                  taskModel:
                                                      filterState[index]))
                                          .then(
                                            (value) => setState(() {
                                              if (value != null) {
                                                filterTaskModel.updatedAt;
                                                selectedStateValue = value;
                                                filterStateFromFb(
                                                    selectedStateValue);
                                              }
                                            }),
                                          );
                                    },
                                    title: Text(
                                      filterTaskModel.title ??
                                          taskModel.title ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                    ),
                                    subtitle: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filterTaskModel.description ??
                                                taskModel.description ??
                                                '',
                                            style:
                                                const TextStyle(fontSize: 14),
                                            maxLines: 4,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            decoration: const BoxDecoration(
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
                                                    '${filterTaskModel.state}'),
                                                filterTaskModel.updatedAt ==
                                                        null
                                                    ? Text(
                                                        '${getFormatedDate(filterTaskModel.createdAt)}')
                                                    : Text(
                                                        'updated ${getFormatedDate(filterTaskModel.updatedAt)}')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    trailing: const Icon(
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
                    return const Center(
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

  void filterStateFromFb(String? query) async {
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
