import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/presentations/features/root/widgets/user_item.dart';
import 'package:manager_apps/presentations/view_models/user/user_model.dart';

import 'package:manager_apps/core/const/app_constants.dart';

class ListUsers extends StatelessWidget {
  const ListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách nhân viên')),
      body: SingleChildScrollView(child: homeListUser(context)),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> homeListUser(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').get().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No User'),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                UserModel? userModel =
                    UserModel.fromMap(snapshot.data!.docs[index].data());
                String? userImage = userModel.profileImage;
                return UserItem(
                  toIndex: index,
                  userImage: userImage,
                  userModel: userModel,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  kSpacingHeight2,
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
