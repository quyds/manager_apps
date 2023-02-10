import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/presentations/features/notification/list/bloc/notification_list_bloc.dart';
import 'package:manager_apps/presentations/features/notification/widgets/notification_item.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';

import 'bloc/notification_list_event.dart';

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
    return BlocBuilder<NotificationListBloc, NotificationListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushNamed('/Main');
                },
              ),
              title: const Text('Thông báo')),
          body: ListView.separated(
            shrinkWrap: true,
            itemCount: listFeed.length,
            itemBuilder: (context, index) {
              FeedItemModel? feedItemModel =
                  FeedItemModel.fromMap(listFeed[index]);
              return Container(
                color: feedItemModel.isChecked == true
                    ? Colors.grey.shade200
                    : Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/ListTask');
                    context
                        .read<NotificationListBloc>()
                        .handleUpdateIsChecked(feedItemModel.id ?? '');
                  },
                  child: NotificationItem(
                    feedItemModel: feedItemModel,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return kSpacingHeight2;
            },
          ),
        );
      },
    );
  }
}
