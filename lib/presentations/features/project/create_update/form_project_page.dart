import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/presentations/view_models/project/project_model.dart';

import 'package:manager_apps/core/extensions/custom_style.dart';

class FormProjectPage extends StatefulWidget {
  const FormProjectPage({super.key});

  @override
  State<FormProjectPage> createState() => _FormProjectPageState();
}

class _FormProjectPageState extends State<FormProjectPage> {
  late TextEditingController titleController;
  late TextEditingController desController;
  final formGlobalKey = GlobalKey<FormState>();

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
        margin: EdgeInsets.only(
            left: Dimension.padding.medium, right: Dimension.padding.medium),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Tạo dự án',
                    style: CustomTextStyle.topTitleOfTextStyle,
                  )
                ],
              ),
            ),
            Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng nhập Tiêu đề!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Tiêu đề',
                      labelStyle: CustomTextStyle.labelOfTextStyle,
                    ),
                    minLines: 1,
                    maxLines: 2,
                    onChanged: (text) {},
                  ),
                  kSpacingHeight10,
                  TextFormField(
                    controller: desController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng nhập Nội dung!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
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
                  kSpacingHeight18,
                  Container(
                    margin: EdgeInsets.only(top: Dimension.padding.medium),
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
                            child: const Text('Trở về'),
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
                            child: const Text('Tạo dự án'),
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                formGlobalKey.currentState!.save();
                                postProjectDetailsToFirestore();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pushNamed('/Main');
  }
}
