import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/const/app_constants.dart';
import 'package:manager_apps/models/feedItem/feedItem_model.dart';

import '../core/extensions/date_format.dart';
import '../core/repositories/get_data_collection_doc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getDataCollection('feedItems'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              FeedItemModel? feedItemModel =
                  FeedItemModel.fromMap(snapshot.data!.docs[index].data());

              String? image = feedItemModel.userProgileImage;

              return ListTile(
                title: GestureDetector(
                  onTap: () {},
                  child: RichText(
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
                                ' đã thêm ${feedItemModel.type} ${feedItemModel.title} cho bạn',
                          ),
                        ]),
                  ),
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
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return kSpacingHeight2;
            },
          );
        },
      ),
    );
  }
}
