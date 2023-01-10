import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/core/repositories/get_data_collection_doc.dart';
import 'package:manager_apps/models/user/user_model.dart';

import '../core/repositories/list_state.dart';
import '../models/task/task_model.dart';

class CreateTaskPage extends StatefulWidget {
  final TaskModel? dataTask;
  const CreateTaskPage({super.key, this.dataTask});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var selectedEmployee, selectedState, selectedProject;

  late TextEditingController titleController;
  late TextEditingController desController;
  late TextEditingController estimateTimeController;
  late TextEditingController completeTimeController;

  @override
  void initState() {
    if (widget.dataTask == null) {
      titleController = TextEditingController();
      desController = TextEditingController();
      estimateTimeController = TextEditingController();
      completeTimeController = TextEditingController();
    } else {
      titleController = TextEditingController(text: widget.dataTask?.title);
      desController = TextEditingController(text: widget.dataTask?.description);
      estimateTimeController =
          TextEditingController(text: widget.dataTask?.estimateTime);
      completeTimeController =
          TextEditingController(text: widget.dataTask?.completeTime);
      selectedEmployee = widget.dataTask?.employee;
      selectedState = widget.dataTask?.state;
      selectedProject = widget.dataTask?.project;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.dataTask == null
                      ? Text(
                          'New Task',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                      : Text(
                          'Edit Task',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                ],
              ),
            ),
            Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Title',
                    labelStyle: CustomTextStyle.labelOfTextStyle,
                  ),
                  minLines: 1,
                  maxLines: 2,
                  onChanged: (text) {},
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: estimateTimeController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                          labelText: 'Estimate Time',
                          labelStyle: CustomTextStyle.labelOfTextStyle,
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: completeTimeController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                          labelText: 'Complete Time',
                          labelStyle: CustomTextStyle.labelOfTextStyle,
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                    labelText: 'Description',
                    labelStyle: CustomTextStyle.labelOfTextStyle,
                  ),
                  minLines: 2,
                  maxLines: 5,
                  onChanged: (text) {},
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                'State',
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.labelOfTextStyle,
                              ),
                            ),
                          ),
                          Container(
                            // width: 220,
                            child: DropdownButton<String>(
                              hint: Text('Chọn trạng thái'),
                              value: selectedState,
                              elevation: 16,
                              style: CustomTextStyle.subOfTextStyle,
                              underline: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                'Employee',
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.labelOfTextStyle,
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: getDataCollection('users'),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return new CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem> currencyItems = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  currencyItems.add(
                                    DropdownMenuItem(
                                      child: Text(
                                        snap['name'],
                                        style: CustomTextStyle.subOfTextStyle,
                                      ),
                                      value: "${snap.id}",
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    DropdownButton(
                                      hint: Text('Chọn nhân viên'),
                                      elevation: 16,
                                      style: CustomTextStyle.subOfTextStyle,
                                      underline: Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      value: selectedEmployee,
                                      isExpanded: false,
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Da chon !',
                                            style: TextStyle(
                                              color: Color(0xff11b719),
                                            ),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          selectedEmployee = currencyValue;
                                          print(selectedEmployee);
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Project',
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: getDataCollection('projects'),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return new CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem> currencyItems = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  currencyItems.add(
                                    DropdownMenuItem(
                                      child: SizedBox(
                                        width: 80,
                                        child: Text(
                                          snap['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyle.subOfTextStyle,
                                        ),
                                      ),
                                      value: "${snap.id}",
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    DropdownButton(
                                      hint: Text('Chọn dự án'),
                                      elevation: 16,
                                      style: CustomTextStyle.subOfTextStyle,
                                      underline: Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      value: selectedProject,
                                      isExpanded: false,
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Da chon !',
                                            style: TextStyle(
                                              color: Color(0xff11b719),
                                            ),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          selectedProject = currencyValue;
                                          print(
                                              'selectedProject ${selectedProject}');
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: Text('Back'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: widget.dataTask == null
                              ? Text('Create Task')
                              : Text('Edit Task'),
                          onPressed: () {
                            print('111 ${widget.dataTask}');
                            widget.dataTask == null
                                ? postTaskDetailsToFirestore()
                                : updateTaskDetail(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  updateTaskDetail(BuildContext context) async {
    Map<String, dynamic> map = Map();

    map['title'] = titleController.text;
    map['description'] = desController.text;
    map['estimateTime'] = estimateTimeController.text;
    map['completeTime'] = completeTimeController.text;
    map['state'] = selectedState;
    map['employee'] = selectedEmployee;
    map['updatedAt'] = FieldValue.serverTimestamp();
    map['project'] = selectedProject;

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.dataTask?.id)
        .update(map);

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(selectedProject)
        .update({
      'taskArray': FieldValue.arrayUnion([widget.dataTask?.id])
    });

    Navigator.pop(context, widget.dataTask?.state);
  }

  void postTaskDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final idTask = firebaseFirestore.collection('tasks').doc().id;

    TaskModel taskModel = TaskModel(
      id: idTask,
      title: titleController.text,
      description: desController.text,
      estimateTime: estimateTimeController.text,
      completeTime: completeTimeController.text,
      state: selectedState,
      employee: selectedEmployee,
      project: selectedProject,
    );

    await firebaseFirestore
        .collection('tasks')
        .doc(idTask)
        .set(taskModel.toMap());

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(selectedProject)
        .update({
      'taskArray': FieldValue.arrayUnion([idTask])
    });

    const snackBar = SnackBar(
      content: Text('Đăng ký thành công !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pushNamed('/ListTask');
  }
}
