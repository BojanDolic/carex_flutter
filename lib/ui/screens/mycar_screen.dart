import 'package:carex_flutter/services/bloc/blocs/myvehicle_bloc.dart';
import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/myvehicle_bloc_states.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_arguments.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/screens/add_cost_screen.dart';
import 'package:carex_flutter/ui/screens/statistics_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/ui/widgets/heading_container.dart';
import 'package:carex_flutter/ui/widgets/list_cost_item.dart';
import 'package:carex_flutter/ui/widgets/list_date_header.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/extensions.dart';
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
                  vehicle: state.selectedVehicle,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: InterfaceUtil.allBorderRadius16,
                        color: Colors.white,
                      ),
                      child: selectedVehicle != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    WidgetUtil.getVehiclePicture(selectedVehicle.imagePath, 60),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    Text("${state.averageConsumption.toStringAsFixed(2)} l/100km")
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(context, StatisticsScreen.id),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Iconsax.graph,
                                          ),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text(
                                            "Statistics",
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    TextButton(
                                      onPressed: () => openCarSelectionDialog(context, selectedVehicle, vehicles),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Iconsax.car,
                                          ),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text(
                                            "Change vehicle",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                  const Text("Last two fuel prices:"),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final fillUp = state.lastFillups[index];
                                      if (index == 0 && state.lastFillups.length > 1) {
                                        final previousFillUp = state.lastFillups[index + 1];

                                        return LastTwoFuelPricesWidget(
                                          fillUp: fillUp,
                                          previousFillUp: previousFillUp,
                                        );
                                      } else {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(
                                            Iconsax.gas_station3,
                                            color: Colors.black87,
                                          ),
                                          title: Text(fillUp.pricePerLiter.formatNumberCurrencyToString(context)),
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
                                  const Text("Last fuel price:"),
                                  ListTile(
                                    leading: const Icon(Iconsax.dollar_square),
                                    title: state.lastFillups.isNotEmpty
                                        ? Text(
                                            state.lastFillups[0].pricePerLiter.formatNumberCurrencyToString(context),
                                          )
                                        : const Text("No data"),
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Error loading data!"),
            ),
          );
        }
      },
    );
  }

  _editCostNavigate(BuildContext context, Vehicle vehicle, Cost cost) {
    final args = AddCostArguments(vehicle: vehicle, cost: cost);

    Navigator.pushNamed(context, AddCostScreen.id, arguments: args);
  }

  /*/// Checks if last refill was cheaper than refill before that
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
  }*/

  void _deleteItem(BuildContext context, cost, Vehicle vehicle) {
    BlocProvider.of<MyVehicleBloc>(context).add(
      DeleteCost(cost: cost, selectedVehicle: vehicle),
    );
  }

  openCarSelectionDialog(BuildContext context, Vehicle vehicle, List<Vehicle> vehicles) {
    if (vehicles.isEmpty) {
      SnackBarUtil.showInfoSnackBar(context, "There are no other vehicles!");
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Select vehicle"),
          shape: InterfaceUtil.allCornerRadiusRoundedRectangle16,
          children: List<Widget>.generate(
            vehicles.length,
            (index) {
              final _vehicle = vehicles[index];
              return SimpleDialogOption(
                onPressed: () => _selectVehicle(_vehicle),
                child: Row(
                  children: [
                    WidgetUtil.getVehiclePicture(_vehicle.imagePath, 50),
                    const SizedBox(
                      width: 9,
                    ),
                    Text(
                      _vehicle.model,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Passes event to bloc to select vehicle and closes dialog
  _selectVehicle(Vehicle vehicle) {
    if (vehicle.id == 0) {
      return;
    }
    BlocProvider.of<MyVehicleBloc>(context).add(
      SelectVehicle(vehicle: vehicle),
    );
    Navigator.pop(context);
  }
}

class LastTwoFuelPricesWidget extends StatelessWidget {
  const LastTwoFuelPricesWidget({
    Key? key,
    required this.fillUp,
    required this.previousFillUp,
  }) : super(key: key);

  final Cost fillUp;
  final Cost previousFillUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Iconsax.gas_station3,
            color: Colors.black87,
          ),
          title: Text(
            "${fillUp.pricePerLiter.formatNumberCurrencyToString(context)} | ${getPercentageDifference().toStringAsFixed(2)}%",
            style: TextStyle(
              color: getPercentageDifference() != 0.0
                  ? getPercentageDifference() > 0.0
                      ? Colors.red
                      : Colors.green
                  : Colors.black,
            ),
          ),
          subtitle: Text(
            DateFormat("dd MMMM HH:MM").format(
              DateTime.parse("${fillUp.date} ${fillUp.time}"),
            ),
            style: theme.textTheme.displaySmall?.copyWith(color: Colors.black54),
          ),
        ),
        Visibility(
          visible: getPercentageDifference() < 0,
          child: Text(
            "You saved ${getSavedPrice().formatNumberCurrencyToString(context)} based on previous fuel price!",
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        )
      ],
    );
  }

  /// Gets percentage of difference between last two fill-up fuel prices
  double getPercentageDifference() {
    var percentage = 0.0;

    percentage = 100 * (fillUp.pricePerLiter - previousFillUp.pricePerLiter) / (previousFillUp.pricePerLiter);

    return percentage;
  }

  /// Gets how much money user saved if he filled up the vehicle
  /// with the same amount of fuel as the last fill-up but with the fuel price
  /// antecedent of the last fuel price.
  double getSavedPrice() {
    final totalPriceCheaper = fillUp.totalPrice;
    final totalPriceExpensive = previousFillUp.pricePerLiter * fillUp.litersFilled;

    final savedPrice = totalPriceExpensive - totalPriceCheaper;
    return savedPrice;
  }
}
