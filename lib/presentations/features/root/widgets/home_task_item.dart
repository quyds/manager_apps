import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/core/repositories/list_state.dart';

class HomeTaskItem extends StatefulWidget {
  final int? toIndex;
  final List? toNameList;
  final int? toTaskLength;
  const HomeTaskItem(
      {super.key, this.toIndex, this.toNameList, this.toTaskLength});

  @override
  State<HomeTaskItem> createState() => _HomeTaskItemState();
}

class _HomeTaskItemState extends State<HomeTaskItem> {
  late int? index = widget.toIndex;
  late List? nameList = widget.toNameList;

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/ListTask', arguments: list[index!]);
      },
      leading: Container(
        height:
            screenSizeWidth < 600 ? screenSizeWidth / 9 : screenSizeWidth / 17,
        width:
            screenSizeWidth < 600 ? screenSizeWidth / 9 : screenSizeWidth / 17,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade900,
        ),
        alignment: Alignment.center,
        child: Icon(
          icons[index!],
          color: Colors.white,
        ),
      ),
      title: Text(
        nameList?[index!],
        style: CustomTextStyle.titleOfTextStyle,
      ),
      subtitle: Text(
        '${widget.toTaskLength} Công việc',
        style: CustomTextStyle.subOfTextStyle,
      ),
    );
    ;
  }
}
