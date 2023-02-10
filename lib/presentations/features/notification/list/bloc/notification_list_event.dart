import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';

abstract class NotificationListEvent {
  const NotificationListEvent();
}

class NotificationRequested extends NotificationListEvent {}
