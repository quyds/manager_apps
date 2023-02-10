import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manager_apps/core/extensions/date_format.dart';
import 'package:manager_apps/presentations/features/notification/list/bloc/notification_list_bloc.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';

class NotificationItem extends StatelessWidget {
  final FeedItemModel? feedItemModel;
  final Function? removedNotification;
  const NotificationItem(
      {super.key, this.feedItemModel, this.removedNotification});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // flex: 1,
            onPressed: (value) {
              context
                  .read<NotificationListBloc>()
                  .handleRemovedNotification(context, feedItemModel!.id!);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: ListTile(
        title: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: feedItemModel?.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' đã thêm ${feedItemModel?.type} ${feedItemModel?.title}',
                ),
              ]),
        ),
        leading: feedItemModel?.userProgileImage != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(feedItemModel!.userProgileImage!),
              )
            : const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
        subtitle: Text(
          StringExtension.displayTimeAgoFromTimestamp(
              feedItemModel!.createdAt.toString()),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
