import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';

class HomeTitle extends StatelessWidget {
  final String? title;
  const HomeTitle({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimension.padding.medium, bottom: Dimension.padding.medium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
