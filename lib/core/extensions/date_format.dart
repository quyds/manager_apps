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
