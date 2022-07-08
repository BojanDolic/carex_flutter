import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/bloc/myvehicle_bloc.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/screens/main_screen.dart';
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
          maintainState: false,
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) => BlocProvider(
            create: (BuildContext context) => MyVehicleBloc(
              RepositoryProvider.of<Repository>(context),
            )..add(
                LoadVehicles(
                  vehicles: RepositoryProvider.of<Repository>(context).getAllVehicles(),
                  selectedVehicle: RepositoryProvider.of<Repository>(context).getSelectedVehicle(),
                ),
              ),
            child: const MyCarScreen(),
          ),
        );
      }
    case VehiclesScreen.id:
      {
        return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) => VehiclesScreen(),
        );
      }
    case AddVehicleScreen.id:
      {
        return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) => const AddVehicleScreen(),
        );
      }
    case MainScreen.id:
      {
        return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) => const MainScreen(),
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
