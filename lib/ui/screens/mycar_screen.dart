import 'package:carex_flutter/services/bloc/blocs/myvehicle_bloc.dart';
import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/myvehicle_bloc_states.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_arguments.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/screens/add_cost_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/ui/widgets/heading_container.dart';
import 'package:carex_flutter/ui/widgets/list_cost_item.dart';
import 'package:carex_flutter/ui/widgets/list_date_header.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  static const id = "/";

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

late ThemeData theme;
late SettingsProvider settings;

class _MyCarScreenState extends State<MyCarScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    settings = SettingsProvider.get(context);
    return BlocBuilder<MyVehicleBloc, MyVehicleBlocState>(
      builder: (BuildContext context, state) {
        if (state is LoadedVehicleState) {
          final vehicles = state.allVehicles;
          final selectedVehicle = state.selectedVehicle;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (selectedVehicle == null) {
                  SnackBarUtil.showInfoSnackBar(context, "No vehicle selected!");
                  return;
                }
                final args = AddCostArguments(
                  vehicle: selectedVehicle,
                );
                Navigator.pushNamed(context, AddCostScreen.id, arguments: args);
              },
              child: const Icon(Iconsax.add),
            ),
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              elevation: 0,
              title: Text("Selected car"),
            ),
            drawer: const CarexDrawer(
              currentRoute: MyCarScreen.id,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: InterfaceUtil.allBorderRadius16,
                          color: Colors.white,
                        ),
                        child: vehicles.isNotEmpty
                            ? Column(
                                children: [
                                  WidgetUtil.getVehiclePicture(selectedVehicle?.imagePath, 60),
                                  Text("${state.averageConsumption.toStringAsFixed(2)} l/100km")
                                ],
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
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Visibility(
                    visible: state.lastFillups.isNotEmpty,
                    child: HeadingContainer(
                      headText: "Fuel price",
                      children: [
                        state.lastFillups.length > 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Last two fuel prices:"),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final fillUp = state.lastFillups[index];
                                      double percentage = 0.0;
                                      if (index == 0 && state.lastFillups.length > 1) {
                                        final previousFillup = state.lastFillups[index + 1];

                                        percentage =
                                            100 * (fillUp.pricePerLiter - state.lastFillups[1].pricePerLiter) / (state.lastFillups[1].pricePerLiter);

                                        if (percentage < 0) {
                                          // Calculate how much is saved
                                          final totalPriceCheaper = fillUp.totalPrice;
                                          final totalPriceExpensive = previousFillup.pricePerLiter * fillUp.litersFilled;

                                          final savedPrice = totalPriceExpensive - totalPriceCheaper;

                                          return Column(
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                  Iconsax.gas_station3,
                                                  color: Colors.black87,
                                                ),
                                                title: Text(
                                                  "${fillUp.pricePerLiter.toStringAsFixed(2)} ${settings.getCurrency()} | ${percentage.toStringAsFixed(2)}%",
                                                  style: TextStyle(
                                                    color: percentage > 0 ? Colors.red : Colors.green,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  DateFormat("dd MMMM HH:MM").format(
                                                    DateTime.parse("${fillUp.date} ${fillUp.time}"),
                                                  ),
                                                  style: theme.textTheme.displaySmall?.copyWith(color: Colors.black54),
                                                ),
                                              ),
                                              Text(
                                                "You saved ${savedPrice.toStringAsFixed(2)} ${settings.getCurrency()} based on previous fuel price!",
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              )
                                            ],
                                          );
                                        } else {
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                              Iconsax.gas_station3,
                                              color: Colors.black87,
                                            ),
                                            title: Text(
                                              "${fillUp.pricePerLiter.toStringAsFixed(2)} ${settings.getCurrency()} | ${percentage.toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                color: percentage > 0 ? Colors.red : Colors.green,
                                              ),
                                            ),
                                            subtitle: Text(
                                              DateFormat("dd MMMM HH:MM").format(
                                                DateTime.parse("${fillUp.date} ${fillUp.time}"),
                                              ),
                                              style: theme.textTheme.displaySmall?.copyWith(color: Colors.black54),
                                            ),
                                          );
                                        }
                                      } else {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(
                                            Iconsax.gas_station3,
                                            color: Colors.black87,
                                          ),
                                          title: Text("${fillUp.pricePerLiter.toStringAsFixed(2)} ${settings.getCurrency()}"),
                                          subtitle: Text(
                                            DateFormat("dd MMMM HH:MM").format(
                                              DateTime.parse("${fillUp.date} ${fillUp.time}"),
                                            ),
                                            style: theme.textTheme.displaySmall?.copyWith(color: Colors.black54),
                                          ),
                                        );
                                      }
                                    },
                                    shrinkWrap: true,
                                    itemCount: state.lastFillups.length,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Last fuel price:"),
                                  ListTile(
                                    leading: Icon(Iconsax.dollar_square),
                                    title:
                                        state.lastFillups.isNotEmpty ? Text(state.lastFillups[0].pricePerLiter.toStringAsFixed(2)) : Text("No data"),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  selectedVehicle != null
                      ? state.thisMonthCosts.isNotEmpty
                          ? Expanded(
                              child: GroupedListView<Cost, String>(
                                elements: state.thisMonthCosts,
                                groupBy: (cost) => "${DateTime.parse(cost.date).month}",
                                order: GroupedListOrder.DESC,
                                groupHeaderBuilder: (cost) {
                                  return DateHeaderWidget(cost: cost);
                                },
                                itemComparator: (cost1, cost2) {
                                  return DateTime.parse("${cost1.date} ${cost1.time}").compareTo(DateTime.parse("${cost2.date} ${cost2.time}"));
                                },
                                itemBuilder: (context, costItem) {
                                  return ListCostItem(
                                    cost: costItem,
                                    onTap: () => _editCostNavigate(context, selectedVehicle, costItem),
                                    onDismiss: (direction) {
                                      if (direction == DismissDirection.startToEnd) {
                                        _deleteItem(context, costItem, state.selectedVehicle!);
                                        SnackBarUtil.showInfoSnackBar(context, "Item deleted!");
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : const Text(
                              "There are no costs added for this month!",
                              textAlign: TextAlign.center,
                            )
                      : const Text(
                          "No vehicle to display data!",
                          textAlign: TextAlign.center,
                        ),
                ],
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

  _editCostNavigate(BuildContext context, Vehicle vehicle, Cost cost) {
    final args = AddCostArguments(vehicle: vehicle, cost: cost);

    Navigator.pushNamed(context, AddCostScreen.id, arguments: args);
  }

  /// Checks if last refill was cheaper than refill before that
  bool _isCheaper(List<Cost> lastFillups) {
    return lastFillups[0].pricePerLiter < lastFillups[1].pricePerLiter;
  }

  String _getFuelCostPercentage(List<Cost> lastFillups) {
    final percentage = 100 * ((lastFillups[1].pricePerLiter - lastFillups[0].pricePerLiter) / (lastFillups[1].pricePerLiter));

    print(lastFillups);

    if (percentage < 0) {
      return "More expensive by ${percentage.abs().toStringAsFixed(2)}%";
    } else if (percentage > 0) {
      return "Cheaper by ${percentage.abs().toStringAsFixed(2)}% ";
    } else {
      return "";
    }
  }

  void _deleteItem(BuildContext context, cost, Vehicle vehicle) {
    BlocProvider.of<MyVehicleBloc>(context).add(
      DeleteCost(cost: cost, selectedVehicle: vehicle),
    );
  }
}

/*DropdownButton<Vehicle>(
                                hint: Text("Select vehicle"),
                                autofocus: false,
                                isExpanded: true,
                                value: state.allVehicles.firstWhere((element) => element.selected),
                                dropdownColor: Colors.white,
                                borderRadius: InterfaceUtil.allBorderRadius16,
                                elevation: 2,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: theme.primaryColor,
                                ),
                                underline: const SizedBox(),
                                items: state.allVehicles.map(
                                  (vehicle) {
                                    return DropdownMenuItem<Vehicle>(
                                      value: vehicle,
                                      enabled: vehicle != state.selectedVehicle,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        dense: true,
                                        leading: WidgetUtil.getVehiclePicture(vehicle.imagePath, 60),
                                        title: Text(
                                          vehicle.model,
                                          style: theme.textTheme.displayMedium,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (vehicle) => _selectVehicle(vehicle),
                              )*/
