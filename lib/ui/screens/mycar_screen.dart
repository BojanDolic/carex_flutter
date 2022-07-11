import 'dart:io';

import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/bloc/myvehicle_bloc.dart';
import 'package:carex_flutter/services/bloc/states/myvehicle_bloc_states.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  static const id = "/";

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

late ThemeData theme;

class _MyCarScreenState extends State<MyCarScreen> {
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BlocBuilder<MyVehicleBloc, MyVehicleBlocState>(
      builder: (BuildContext context, state) {
        if (state is LoadedVehicleState) {
          final vehicles = state.allVehicles;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text("Selected car"),
              bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: InterfaceUtil.allBorderRadius16,
                      color: Colors.white,
                    ),
                    child: vehicles.isNotEmpty
                        ? DropdownButton<Vehicle>(
                            hint: Text("Select vehicle"),
                            autofocus: false,
                            isExpanded: true,
                            value: state.selectedVehicle,
                            dropdownColor: Colors.white,
                            borderRadius: InterfaceUtil.allBorderRadius16,
                            elevation: 2,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: theme.primaryColor,
                            ),
                            underline: const SizedBox(),
                            items: List<Vehicle>.of(vehicles).map(
                              (vehicle) {
                                return DropdownMenuItem<Vehicle>(
                                  value: vehicle,
                                  child: ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      backgroundImage: vehicle.imagePath != null
                                          ? FileImage(
                                              File(vehicle.imagePath!),
                                            )
                                          : Image.asset("assets/placeholder_car.jpg").image,
                                    ),
                                    title: Text(
                                      vehicle.model,
                                      style: theme.textTheme.displayMedium,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (vehicle) => _selectVehicle(vehicle),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("You need to add vehicle."),
                              MaterialButton(
                                onPressed: () {},
                                child: Icon(Icons.add),
                                color: theme.primaryColor,
                                elevation: 0,
                                shape: InterfaceUtil.allCornerRadiusRoundedRectangle16,
                              ),
                            ],
                          ),
                  ),
                ),
                preferredSize: Size.fromHeight(65),
              ),
            ),
            drawer: const CarexDrawer(
              currentRoute: MyCarScreen.id,
            ),
            body: Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text("Title dialog"),
                    ),
                  );
                },
                child: Text(
                  "Home page my car screen",
                ),
              ),
            ),
          );
        } else if (state is InitialState) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text("Error loading data!"),
            ),
          );
        }
      },
    );
  }

  _selectVehicle(Vehicle? vehicle) {
    if (vehicle == null) {
      return;
    }

    if (vehicle.selected) {
      return;
    }

    BlocProvider.of<MyVehicleBloc>(context).add(
      SelectVehicle(vehicle: vehicle),
    );
  }
}
