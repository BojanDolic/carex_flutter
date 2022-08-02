import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/data_contants.dart';
import 'package:flutter/cupertino.dart';

extension EnumExtension on CostType {
  List<String> toStringItemsList() {
    const costTypes = CostType.values;
    final listOfTypes = List<String>.empty();
    for (CostType type in costTypes) {
      final _name = type.name.replaceRange(0, 1, type.name[0].toUpperCase());
      listOfTypes.add(_name);
    }
    return listOfTypes;
  }
}

extension NumFormatting on num {
  String formatNumberCurrencyToString(BuildContext context, {int digits = 2}) {
    final settings = SettingsProvider.get(context);
    final currency = settings.getCurrency();
    if (digits < 1) {
      digits = 1;
    }

    if (currency == "\$" || currency == "£") {
      return "$currency${toStringAsFixed(digits)}";
    } else {
      return "${toStringAsFixed(digits)} $currency";
    }
  }
}
