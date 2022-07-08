import 'package:flutter/material.dart';

class InterfaceUtil {
  static const allBorderRadius16 = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
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
