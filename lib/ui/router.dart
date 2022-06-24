import 'package:carex_flutter/ui/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoutes(RouteSettings settings) {
  final route = settings.name;

  switch (route) {
    case MainScreen.id:
      {
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      }
  }
}
