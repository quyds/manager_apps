import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/date_format.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';

class NotificationItem extends StatelessWidget {
  final FeedItemModel? feedItemModel;
  const NotificationItem({super.key, this.feedItemModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                text: ' đã thêm ${feedItemModel?.type} ${feedItemModel?.title}',
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
    );
  }
}
