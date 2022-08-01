import 'dart:io';

import 'package:carex_flutter/util/constants/color_constants.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class WidgetUtil {
  static Widget getIconBasedOnCostType(String costType, [double iconSize = 32]) {
    switch (costType) {
      case "Fuel":
        {
          return Icon(
            Iconsax.gas_station,
            color: Colors.red,
            size: iconSize,
          );
        }
      case "Service":
        {
          return Icon(
            Icons.build_outlined,
            color: Colors.blue,
            size: iconSize,
          );
        }
      case "Maintenance":
        {
          return Icon(
            Iconsax.setting_2,
            color: mainColor,
            size: iconSize,
          );
        }
      case "Parking":
        {
          return Icon(
            Icons.local_parking_outlined,
            color: Colors.green,
            size: iconSize,
          );
        }
      case "Registration":
        {
          return Icon(
            Iconsax.note_1,
            color: Colors.deepPurple,
            size: iconSize,
          );
        }
      default:
        {
          return Icon(
            Icons.error,
            size: iconSize,
          );
        }
    }
  }
/*
  "Parking",
  "Registration",*/

  static Widget getVehiclePicture(String? imagePath, double size, [double? borderRadius]) {
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : InterfaceUtil.allBorderRadius9,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: size,
          height: size * .8,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : InterfaceUtil.allBorderRadius9,
        child: Image.asset(
          "assets/placeholder_car.jpg",
          fit: BoxFit.cover,
        ),
      );
    }
  }
}

class ColorUtil {
  static Color getColorBasedOnCostType(String costType) {
    switch (costType) {
      case "Fuel":
        {
          return Colors.red;
        }
      case "Service":
        {
          return Colors.blue;
        }
      case "Maintenance":
        {
          return mainColor;
        }
      case "Registration":
        {
          return Colors.deepPurple;
        }
      case "Parking":
        {
          return Colors.green;
        }
      default:
        {
          return mainColor;
        }
    }
  }
}

class SnackBarUtil {
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration,
      ),
    );
  }
}

class ValidatorUtil {
  static String? validateEmptyText(
    String? value, {
    String errorMessage = "Field can't be empty",
  }) {
    if (value != null && value.isNotEmpty) {
      return null;
    } else {
      return errorMessage;
    }
  }
}

class ParserUtil {
  static String parseTimeISO8601(TimeOfDay time) {
    String formattedTime = "";

    final hour = time.hour;
    final minute = time.minute;

    final formattedHour = hour < 10 ? "0$hour" : "$hour";
    final formattedMinutes = minute < 10 ? "0$minute" : "$minute";

    formattedTime = "$formattedHour:$formattedMinutes";
    return formattedTime;
  }

  static String parseDateISO8601(DateTime date) {
    String formattedTime = "";

    final year = date.year;
    final month = date.month;
    final day = date.day;

    final formattedYear = "$year";
    final formattedMonth = month < 10 ? "0$month" : "$month";
    final formattedDay = day < 10 ? "0$day" : "$day";

    formattedTime = "$formattedYear-$formattedMonth-$formattedDay";
    return formattedTime;
  }
}
