import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/data/models/user_arguments_model.dart';
import 'package:manager_apps/presentations/view_models/user/user_model.dart';

class UserItem extends StatelessWidget {
  final int? toIndex;
  final String? userImage;
  final UserModel? userModel;
  const UserItem({super.key, this.toIndex, this.userImage, this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/EditProfile',
            arguments: UserArguments(userModel: userModel));
      },
      leading: Container(
        width: 46,
        height: 46,
        margin: EdgeInsets.only(
            left: Dimension.padding.small, right: Dimension.padding.small),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: userImage == null
              ? const DecorationImage(
                  image: AssetImage('assets/images/avatar.png'),
                  fit: BoxFit.contain)
              : DecorationImage(
                  image: NetworkImage(userImage!),
                  fit: BoxFit.contain,
                ),
        ),
      ),
      title: Text(userModel?.name ?? ''),
      subtitle: Text(userModel?.level ?? ''),
    );
  }
}
