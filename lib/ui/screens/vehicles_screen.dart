import 'dart:io';

import 'package:carex_flutter/services/bloc/blocs/vehicles_bloc.dart';
import 'package:carex_flutter/services/bloc/events/vehicles_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/vehicles_bloc_states.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/util/constants/data_contants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({
    Key? key,
  }) : super(key: key);

  static const id = "/vehicles";

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  //final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: const CarexDrawer(
        currentRoute: VehiclesScreen.id,
      ),
      appBar: AppBar(
        title: const Text("Vehicles"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddVehicleScreen.id),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<VehiclesBloc, VehiclesState>(
        builder: (BuildContext context, state) {
          if (state is LoadedVehicles) {
            return ListView.builder(
              itemCount: state.vehicles.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final vehicle = state.vehicles[index];
                if (state.vehicles.length == 1) {
                  WidgetsBinding.instance?.addPostFrameCallback(
                    (timeStamp) {
                      _handleSelection(state.vehicles.first);
                    },
                  );
                }
                return VehicleItem(
                  vehicle: vehicle,
                  onLongPress: () => _handleDelete(vehicle),
                  onPopupItemSelected: (value) => _handlePopupMenuSelection(value, vehicle),
                  onTap: () => _editVehicle(vehicle),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _handleDelete(Vehicle vehicle) {
    showDialog(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Delete this vehicle ?"),
            content: Text("Are you sure you want delete ${vehicle.model} from your vehicles list ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Exit",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteVehicle(vehicle);
                },
                child: Text(
                  "Delete",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _deleteVehicle(Vehicle vehicle) {
    BlocProvider.of<VehiclesBloc>(context).add(
      DeleteVehicle(vehicle: vehicle),
    );
    SnackBarUtil.showInfoSnackBar(
      context,
      "${vehicle.model} deleted",
      duration: const Duration(seconds: 2),
    );
  }

  _handlePopupMenuSelection(VehiclesMenuOptions value, Vehicle vehicle) {
    switch (value) {
      case VehiclesMenuOptions.selectVehicle:
        _handleSelection(vehicle);
        break;
      case VehiclesMenuOptions.deleteVehicle:
        _handleDelete(vehicle);
        break;
    }
  }

  void _handleSelection(Vehicle vehicle) {
    if (vehicle.selected) {
      return;
    }
    BlocProvider.of<VehiclesBloc>(context).add(
      SelectVehicle(vehicle: vehicle),
    );
    SnackBarUtil.showInfoSnackBar(
      context,
      "${vehicle.model} selected",
      duration: const Duration(seconds: 2),
    );
  }

  _editVehicle(Vehicle vehicle) {
    Navigator.pushNamed(context, AddVehicleScreen.id, arguments: vehicle);
  }
}

class VehicleItem extends StatelessWidget {
  const VehicleItem({
    Key? key,
    required this.vehicle,
    required this.onLongPress,
    required this.onPopupItemSelected,
    this.onTap,
  }) : super(key: key);

  final Vehicle vehicle;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final void Function(VehiclesMenuOptions)? onPopupItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 200,
        child: Card(
          margin: const EdgeInsets.all(9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: vehicle.imagePath != null
                    ? Image.file(
                        File(vehicle.imagePath ?? ""),
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/placeholder_car.jpg",
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 16,
                  right: 3,
                  bottom: 3,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.model,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .25,
                          ),
                        ),
                      ),
                      PopupMenu(
                        onPopupItemSelected: onPopupItemSelected,
                        vehicle: vehicle,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    Key? key,
    required this.onPopupItemSelected,
    required this.vehicle,
  }) : super(key: key);

  final void Function(VehiclesMenuOptions p1)? onPopupItemSelected;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VehiclesMenuOptions>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(0),
      onSelected: onPopupItemSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: VehiclesMenuOptions.selectVehicle,
            padding: EdgeInsets.zero,
            enabled: !vehicle.selected,
            child: ListTile(
              leading: vehicle.selected
                  ? const Icon(
                      Icons.check_box_outlined,
                      color: Colors.green,
                    )
                  : const Icon(Icons.check),
              title: Text(
                vehicle.selected ? "Selected" : "Select vehicle",
              ),
            ),
          ),
          const PopupMenuItem(
            value: VehiclesMenuOptions.deleteVehicle,
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.delete_outline_rounded),
              title: Text(
                "Delete vehicle",
              ),
            ),
          ),
        ];
      },
    );
  }
}
