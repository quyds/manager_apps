import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(const NotificationListState()) {
    on<NotificationRequested>(_handleNotificationRequested);
  }
  List? filterFeed;
  Future<void> _handleNotificationRequested(
    NotificationRequested event,
    Emitter<NotificationListState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          notificationStatus: NotificationRequest.requestInProgress,
        ),
      );

      final result = await FirebaseFirestore.instance
          .collection('feedItems')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      filterFeed = result.docs.map((element) => element.data()).toList();

      emit(
        state.copyWith(
          notificationStatus: NotificationRequest.requestSuccess,
          notifications: filterFeed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          notificationStatus: NotificationRequest.requestFailure,
        ),
      );
    }
  }

  void handleRemovedNotification(BuildContext context, String id) async {
    FirebaseFirestore.instance.collection('feedItems').doc(id).delete();
    context.read<NotificationListBloc>().add(NotificationRequested());
  }

  void handleUpdateIsChecked(String id) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection('feedItems').doc(id).update({
      'isChecked': false,
    });
  }
}
