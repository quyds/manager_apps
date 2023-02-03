import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/presentations/features/notification/widgets/notification_item.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';

class NotificationPage extends StatefulWidget {
  final Object? feedItemModel;
  const NotificationPage({super.key, this.feedItemModel});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    List? listFeed = widget.feedItemModel as List;
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: listFeed.length,
        itemBuilder: (context, index) {
          FeedItemModel? feedItemModel = FeedItemModel.fromMap(listFeed[index]);

          return Container(
            color: feedItemModel.isChecked == true
                ? Colors.grey.shade200
                : Colors.white,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/ListTask');
                  updateIsChecked(feedItemModel);
                },
                child: NotificationItem(
                  feedItemModel: feedItemModel,
                )),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return kSpacingHeight2;
        },
      ),
    );
  }

  void updateIsChecked(FeedItemModel? feedItemModel) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection('feedItems')
        .doc(feedItemModel?.id)
        .update({
      'isChecked': false,
    });
  }
}
