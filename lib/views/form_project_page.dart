import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/models/project/project_model.dart';

import '../core/extensions/custom_style.dart';

class FormProjectPage extends StatefulWidget {
  const FormProjectPage({super.key});

  @override
  State<FormProjectPage> createState() => _FormProjectPageState();
}

class _FormProjectPageState extends State<FormProjectPage> {
  late TextEditingController titleController;
  late TextEditingController desController;

  @override
  void initState() {
    titleController = TextEditingController();
    desController = TextEditingController();
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
                  Text(
                    'Tạo dự án',
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
                    labelText: 'Tiêu đề',
                    labelStyle: CustomTextStyle.labelOfTextStyle,
                  ),
                  minLines: 1,
                  maxLines: 2,
                  onChanged: (text) {},
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
                    labelText: 'Nội dung',
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
                          child: Text('Trở về'),
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
                          child: Text('Tạo dự án'),
                          onPressed: () {
                            postProjectDetailsToFirestore();
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

  void postProjectDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final idProject = firebaseFirestore.collection('projects').doc().id;

    ProjectModel projectModel = ProjectModel(
      id: idProject,
      title: titleController.text,
      description: desController.text,
    );

    await firebaseFirestore
        .collection('projects')
        .doc(idProject)
        .set(projectModel.toMap());

    const snackBar = SnackBar(
      content: Text('Tạo thành công !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pop();
  }
}
