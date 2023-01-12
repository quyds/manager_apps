import 'package:flutter/material.dart';

class ColorsRandom {
  final String note;
  static List colors = [
    const Color(0xffB85252),
    const Color(0xffB4C6A6),
    const Color(0xffF4ABC4),
    const Color(0xff346751),
    const Color(0xffFFC947),
    const Color(0xff3282B8),
  ];

  ColorsRandom({required this.note});

  static Color getColorItem() => (colors.toList()..shuffle()).first;
}
