import 'package:carex_flutter/services/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';

class SettingsProvider extends InheritedWidget {
  final UserPreferences preferences;

  const SettingsProvider({Key? key, required Widget child, required this.preferences}) : super(key: key, child: child);

  String getCurrency() {
    return preferences.getCurrency();
  }

  Future<bool> updateCurrency(String currency) {
    return preferences.setCurrency(currency);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static SettingsProvider get(BuildContext context) {
    SettingsProvider widget;

    try {
      widget = context.dependOnInheritedWidgetOfExactType<SettingsProvider>()!;
    } catch (e) {
      throw ("Widget of type \"SettingsProvider\" not found inside widget tree.");
    }
    return widget;
  }
}
