import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/screens/vehicles_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoutes(RouteSettings settings) {
  final route = settings.name;

  switch (route) {
    case MyCarScreen.id:
      {
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const MyCarScreen(),
        );
      }
    case VehiclesScreen.id:
      {
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const VehiclesScreen(),
        );
      }
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text("No route found for $route"),
          ),
        ),
      );
  }
}
