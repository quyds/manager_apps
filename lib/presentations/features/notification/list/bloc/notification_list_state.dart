part of 'notification_list_bloc.dart';

enum NotificationRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class NotificationListState {
  const NotificationListState({
    this.notifications = const [],
    this.notificationStatus = NotificationRequest.unknown,
    this.notificationId = const {},
  });

  final List? notifications;
  final NotificationRequest notificationStatus;
  final Set<int> notificationId;

  NotificationListState copyWith({
    List? notifications,
    NotificationRequest? notificationStatus,
    Set<int>? notificationId,
  }) =>
      NotificationListState(
        notifications: notifications ?? this.notifications,
        notificationStatus: notificationStatus ?? this.notificationStatus,
        notificationId: notificationId ?? this.notificationId,
      );
}
