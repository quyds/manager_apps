import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get getStartDate {
    DateFormat transactionDateFormat = DateFormat('dd MMM');
    return transactionDateFormat.format(this);
  }

  String get getDateTime {
    DateFormat transactionDateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    return transactionDateFormat.format(this);
  }
}

convertTimeStamp(Timestamp timestamp) {
  assert(timestamp != null);
  String convertedDate;
  convertedDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());
  return convertedDate;
}

getFormatedDate(DateTime? _date) {
  DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm');
  String format = inputFormat.format(_date!);
  return format;
}
