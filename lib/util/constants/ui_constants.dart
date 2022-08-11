import 'package:flutter/material.dart';

class InterfaceUtil {
  static const allBorderRadius16 = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  );

  static const allBorderRadius9 = BorderRadius.only(
    topLeft: Radius.circular(9),
    topRight: Radius.circular(9),
    bottomRight: Radius.circular(9),
    bottomLeft: Radius.circular(9),
  );

  static const topBorderRadius9 = BorderRadius.only(
    topLeft: Radius.circular(9),
    topRight: Radius.circular(9),
    bottomRight: Radius.circular(0),
    bottomLeft: Radius.circular(0),
  );

  static const topCornerRoundedRectangle16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
  );

  static const allCornerRadiusRoundedRectangle16 = RoundedRectangleBorder(
    borderRadius: allBorderRadius16,
  );
}
