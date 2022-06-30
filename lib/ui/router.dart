import 'package:carex_flutter/main.dart';
import 'package:carex_flutter/services/bloc/vehicles_bloc.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/screens/vehicles_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          pageBuilder: (context, _, __) => RepositoryProvider(
            create: (BuildContext context) => Repository(objectBox),
            child: BlocProvider(
              create: (BuildContext context) => VehiclesBloc(
                RepositoryProvider.of<Repository>(context),
              ),
              child: VehiclesScreen(
                navigatorKey: navigatorKey,
              ),
            ),
          ),
        );
      }
    case AddVehicleScreen.id:
      {
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const AddVehicleScreen(),
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
