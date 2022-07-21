import 'package:carex_flutter/services/bloc/blocs/costs_bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/costs_bloc_states.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/screens/add_cost_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CostsScreen extends StatefulWidget {
  const CostsScreen({Key? key}) : super(key: key);

  static const id = "/costs";

  @override
  State<CostsScreen> createState() => _CostsScreenState();
}

class _CostsScreenState extends State<CostsScreen> {
  var infoExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CarexDrawer(
        currentRoute: CostsScreen.id,
      ),
      appBar: AppBar(
        title: Text("Costs"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final providerState = BlocProvider.of<CostsBloc>(context).state;
          // Error state
          if (providerState is! LoadedCostsState && providerState is! NoCostsState) {
            SnackBarUtil.showInfoSnackBar(context, "Can't add cost right now!");
            return;
          }

          Navigator.pushNamed(context, AddCostScreen.id);
        },
        label: Text("New cost"),
        icon: Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<CostsBloc, CostsBlocStates>(
          builder: (context, state) {
            if (state is LoadedCostsState) {
              return CostsScreenContent(
                selectedVehicle: state.selectedVehicle!,
                costs: state.costs,
                costInfo: state.costsInfo,
                isExpanded: infoExpanded,
                expandedListener: (panelIndex, isExpanded) {
                  print("Expanded clicked $isExpanded");
                  setState(() {
                    infoExpanded = !infoExpanded;
                  });
                },
              );
            } else if (state is CostsInitialState) {
              return InitialScreenContent();
            } else if (state is NoCostsState) {
              return NoCostsScreenContent();
            } else if (state is CostsErrorState) {
              final message = state.errorMessage;
              return ErrorScreenContent(
                errorMessage: message,
              );
            } else if (state is CostsNoSelectedVehicleState) {
              return NoSelectedVehicleScreen();
            } else {
              return Center(
                child: Text("Error loading screen"),
              );
            }
          },
        ),
      ),
    );
  }
}

class NoSelectedVehicleScreen extends StatelessWidget {
  const NoSelectedVehicleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No vehicle is selected!"),
    );
  }
}

class CostsScreenContent extends StatelessWidget {
  const CostsScreenContent({
    Key? key,
    required this.selectedVehicle,
    required this.costs,
    required this.costInfo,
    required this.isExpanded,
    this.expandedListener,
  }) : super(key: key);

  final Vehicle selectedVehicle;
  final List<Cost> costs;
  final Map<String, double> costInfo;
  final void Function(int, bool)? expandedListener;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        /*Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: Container(
            clipBehavior: Clip.none,
            decoration: const BoxDecoration(
              //color: theme.cardColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0,
                  0.1,
                  0.31,
                  0.75,
                  1.0,
                ],
                colors: [
                  Color(0xFFd5d4d0),
                  Color(0xFFd5d4d0),
                  Color(0xFFeeeeec),
                  Color(0xFFefeeec),
                  Color(0xFFe9e9e7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1B020202),
                  blurRadius: 3,
                  offset: Offset(0.5, 1.5),
                ),
              ],
              borderRadius: InterfaceUtil.allBorderRadius16,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(selectedVehicle.model),
                    leading: WidgetUtil.getVehiclePicture(selectedVehicle.imagePath),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  LinearProgressBar(
                    value: costInfo["Fuel"]! / costInfo["Total"]!,
                    label: 'Spent on fuel',
                    endValue: costInfo["Total"]!.toString(),
                  )
                ],
              ),
            ),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: ClipRRect(
            borderRadius: InterfaceUtil.allBorderRadius16,
            child: ExpansionPanelList(
              expansionCallback: expandedListener,
              children: [
                ExpansionPanel(
                  isExpanded: isExpanded,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 16,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(selectedVehicle.model),
                        leading: WidgetUtil.getVehiclePicture(selectedVehicle.imagePath),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        SfCircularChart(
                          series: <CircularSeries>[
                            PieSeries<CostInfo, String>(
                              dataSource: costInfo.entries.map((e) => CostInfo(e.key, e.value)).toList(),
                            ),
                          ],
                        ),
                        LinearProgressBar(
                          value: costInfo["Fuel"]! / costInfo["Total"]!,
                          label: 'Spent on fuel',
                          endValue: costInfo["Fuel"]!.toString(),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        LinearProgressBar(
                          value: costInfo["Service"]! / costInfo["Total"]!,
                          label: 'Spent on service',
                          endValue: costInfo["Service"]!.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GroupedListView<Cost, String>(
            elements: costs.toList(),
            groupBy: (cost) => "${DateTime.parse(cost.date).month}",
            order: GroupedListOrder.DESC,
            groupHeaderBuilder: (cost) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 9,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Text(
                      DateFormat("MMMM yyyy").format(
                        DateTime.parse(cost.date),
                      ),
                    ),
                  ],
                ),
              );
            },
            padding: EdgeInsets.symmetric(
              vertical: 9,
            ),
            //physics: const BouncingScrollPhysics(),
            itemComparator: (cost1, cost2) {
              return DateTime.parse("${cost1.date} ${cost1.time}").compareTo(DateTime.parse("${cost2.date} ${cost2.time}"));
            },
            indexedItemBuilder: (context, cost, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3,
                ),
                child: Dismissible(
                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      return Future.value(false);
                    }
                    return Future.value(true);
                  },
                  key: UniqueKey(),
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: InterfaceUtil.allBorderRadius16,
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _deleteItem(context, cost);
                      SnackBarUtil.showInfoSnackBar(context, "Item deleted!");
                    }
                  },
                  child: ListTile(
                    leading: WidgetUtil.getIconBasedOnCostType(cost.category),
                    title: Text(cost.description),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total: ${cost.totalPrice} KM",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          DateFormat("dd MMMM").format(
                            DateTime.parse(cost.date),
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displaySmall?.copyWith(),
                        ),
                      ],
                    ),
                    tileColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    shape: InterfaceUtil.allCornerRadiusRoundedRectangle16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _deleteItem(BuildContext context, Cost cost) {
    BlocProvider.of<CostsBloc>(context).add(
      DeleteCost(cost: cost),
    );
  }
}

class LinearProgressBar extends StatelessWidget {
  const LinearProgressBar({
    Key? key,
    required this.label,
    required this.endValue,
    required this.value,
  }) : super(key: key);

  final String label;
  final String endValue;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 14,
              ),
            ),
            Text(
              "$endValue KM",
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
        LinearProgressIndicator(
          value: value,
          minHeight: 6,
        ),
      ],
    );
  }
}

class InitialScreenContent extends StatelessWidget {
  const InitialScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NoCostsScreenContent extends StatelessWidget {
  const NoCostsScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("There are no costs added for this vehicle!"),
    );
  }
}

class ErrorScreenContent extends StatelessWidget {
  const ErrorScreenContent({
    Key? key,
    this.errorMessage = "",
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
