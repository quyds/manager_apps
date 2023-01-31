import 'package:flutter/material.dart';
import 'package:manager_apps/const/app_constants.dart';
import 'package:manager_apps/core/repositories/list_state.dart';
import 'package:manager_apps/models/feedItem/feedItem_model.dart';
import '../core/extensions/date_format.dart';

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

          String? image = feedItemModel.userProgileImage;

          return Container(
            color: feedItemModel.isChecked == true
                ? Colors.grey.shade200
                : Colors.white,
            child: InkWell(
              onTap: () {
                print('da click');
              },
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
                          text: feedItemModel.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              ' đã thêm ${feedItemModel.type} ${feedItemModel.title}',
                        ),
                      ]),
                ),
                leading: image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(image),
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                subtitle: Text(
                  StringExtension.displayTimeAgoFromTimestamp(
                      feedItemModel.createdAt.toString()),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return kSpacingHeight2;
        },
      ),
    );
  }
}
