import 'package:flutter/material.dart';

const kSpacer = Spacer();

const kSpacingHeight4 = SizedBox(
  height: 4,
);

const kSpacingHeight2 = SizedBox(
  height: 2,
);

const kSpacingHeight6 = SizedBox(
  height: 6,
);

const kSpacingHeight8 = SizedBox(
  height: 8,
);

const kSpacingHeight10 = SizedBox(
  height: 10,
);

const kSpacingHeight12 = SizedBox(
  height: 12,
);

const kSpacingHeight14 = SizedBox(
  height: 14,
);

const kSpacingHeight16 = SizedBox(
  height: 16,
);

const kSpacingHeight18 = SizedBox(
  height: 18,
);

const kSpacingHeight24 = SizedBox(
  height: 24,
);

const kSpacingHeight32 = SizedBox(
  height: 32,
);

const kSpacingHeight36 = SizedBox(
  height: 36,
);

const kSpacingHeight48 = SizedBox(
  height: 48,
);

const kSpacingWidth2 = SizedBox(
  width: 2,
);

const kSpacingWidth4 = SizedBox(
  width: 4,
);

const kSpacingWidth6 = SizedBox(
  width: 6,
);

const kSpacingWidth8 = SizedBox(
  width: 8,
);

const kSpacingWidth12 = SizedBox(
  width: 12,
);

const kSpacingWidth14 = SizedBox(
  width: 14,
);

const kSpacingWidth16 = SizedBox(
  width: 16,
);

const kSpacingWidth24 = SizedBox(
  width: 24,
);

const kSpacingWidth32 = SizedBox(
  width: 32,
);

const kSpacingWidth48 = SizedBox(
  width: 48,
);

class ColorConstants {
  static const Color bgColor = Color(0xffF4F7FA);
  static const Color bgItemColor = Color(0xffF4F7FA);

  static const Color lineColor = Color(0xFFD0D0D0);
  static const Color primaryColor = gradientStartColor1;
  static const Color textError = Color(0xffC04451);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkText = Colors.black54;
  static const Color darkGrayText = Color(0xff313131);
  static const Color colorGrayText = Color(0xff9B9B9B);
  static const Color highlightColor = Colors.blue;
  static const Color bgLoadingColor = Color(0x50313131);
  static const Color bgLurColor = Color(0x3444c662);
  static const Color whiteGrayColor = Color(0xff9B9B9B);
  static const Color grayColor = Color(0xfff2f2f2);
  static const Color errColor = Colors.red;
  static const Color successColor = Color(0xff44c662);
  static const Color infoColor = Colors.blueAccent;
  static const Color gradientEndColor = Color(0xff1e656d);
  static const Color gradientStartColor = Color(0xff00344d);
  static const Color gradientStartColor1 = Color(0xff155158);
  static const Color borderColor = Color(0xffe0e0e0);
  static const Color endVay247Color = Color(0xff00A800);
}

class Dimension {
  static const padding = _Padding();

  static const runSpacing = _RunSpacing();

  static const spacing = _Spacing();

  static const iconSize = _IconSize();

  static const radius = _Radius();
}

class _Padding {
  final double tiny = 4;

  final double small = 8;

  final double medium = 12;

  final double large = 16;

  final double huge = 20;

  final double gigantic = 24;

  const _Padding();
}

class _RunSpacing {
  final double tiny = 4;

  final double small = 8;

  final double medium = 12;

  final double large = 16;

  final double huge = 20;

  final double gigantic = 24;

  const _RunSpacing();
}

class _Spacing {
  final double tiny = 4;

  final double small = 8;

  final double medium = 12;

  final double large = 16;

  final double huge = 20;

  final double gigantic = 24;

  const _Spacing();
}

class _IconSize {
  final double tiny = 10;

  final double small = 12;

  final double medium = 14;

  final double large = 16;

  final double huge = 18;

  final double gigantic = 20;

  const _IconSize();
}

class _Radius {
  final double tiny = 5;

  final double small = 10;

  final double medium = 15;

  final double large = 20;

  final double gigantic = 40;

  const _Radius();
}

class _Route {
  final String logIn = '/LogIn';
  final String register = '/Register';
  final String main = '/Main';
  final String home = '/Home';

  final String createTask = '/CreateTask';
  final String listTask = '/ListTask';
  final String formProject = '/FormProject';

  final String listProject = '/ListProject';
  final String editProfile = '/EditProfile';
  final String notification = '/Notification';
}
