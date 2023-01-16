import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../const/app_constants.dart';
import '../models/user/user_model.dart';

class MyTaskPage extends StatelessWidget {
  const MyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách nhân viên')),
      body: Container(child: homeListUser(context)),
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('No User')],
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                UserModel? userModel =
                    UserModel.fromMap(snapshot.data!.docs[index].data());
                var userImage = userModel.profileImage;
                return Container(
                    // child: ListTile(
                    //     leading: Container(
                    //       width: 46,
                    //       height: 46,
                    //       margin: EdgeInsets.only(
                    //           left: Dimension.padding.small,
                    //           right: Dimension.padding.small),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         image: userImage == null
                    //             ? const DecorationImage(
                    //                 image: AssetImage('assets/images/avatar.png'),
                    //                 fit: BoxFit.contain)
                    //             : DecorationImage(
                    //                 image: NetworkImage(userImage),
                    //                 fit: BoxFit.contain,
                    //               ),
                    //       ),
                    //     ),
                    //     ),
                    );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
