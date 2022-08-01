import 'package:carex_flutter/services/bloc/blocs/costs_bloc.dart';
import 'package:carex_flutter/services/bloc/blocs/myvehicle_bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/models/cost_arguments.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:carex_flutter/ui/screens/add_cost_screen.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/screens/costs_screen.dart';
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
          pageBuilder: (context, _, __) {
            final vehicleArgs = (settings.arguments) as Vehicle?;
            return AddVehicleScreen(
              vehicle: vehicleArgs,
            );
          },
        );
      }
    case CostsScreen.id:
      {
        return PageRouteBuilder(
          transitionDuration: Duration.zero,
          maintainState: false,
          pageBuilder: (context, _, __) => BlocProvider<CostsBloc>(
            create: (context) => CostsBloc(
              RepositoryProvider.of<Repository>(context),
            )..add(
                const LoadCosts(),
              ),
            child: const CostsScreen(),
          ),
        );
      }
    case AddCostScreen.id:
      {
        final args = (settings.arguments) as AddCostArguments?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider<CostsBloc>(
            create: (context) => CostsBloc(
              RepositoryProvider.of<Repository>(context),
            ),
            child: AddCostScreen(
              selectedVehicle: args?.vehicle,
              cost: args?.cost,
            ),
          ),
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
