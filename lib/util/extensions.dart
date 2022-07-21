import 'package:carex_flutter/util/constants/data_contants.dart';

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
