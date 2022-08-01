import 'package:carex_flutter/services/bloc/blocs/costs_bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/costs_bloc_states.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_arguments.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/screens/add_cost_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/ui/widgets/list_date_header.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/color_constants.dart';
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
    return WillPopScope(
      onWillPop: () {
        if (infoExpanded) {
          setState(() {
            infoExpanded = false;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        drawer: const CarexDrawer(
          currentRoute: CostsScreen.id,
        ),
        appBar: AppBar(
          title: const Text("Costs"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final providerState = BlocProvider.of<CostsBloc>(context).state;
            // Error state
            if (providerState is LoadedCostsState || providerState is NoCostsState) {
              Vehicle? selectedVehicle;

              try {
                selectedVehicle = (providerState as LoadedCostsState).selectedVehicle;
              } on Exception {
                selectedVehicle = (providerState as NoCostsState).selectedVehicle;
              }

              final args = AddCostArguments(vehicle: selectedVehicle);
              Navigator.pushNamed(context, AddCostScreen.id, arguments: args);
            } else {
              SnackBarUtil.showInfoSnackBar(context, "Can't add cost right now!");
              return;
            }
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
                  yearCosts: state.yearCosts,
                  isExpanded: infoExpanded,
                  expandedListener: (panelIndex, isExpanded) {
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
    required this.yearCosts,
    required this.isExpanded,
    this.expandedListener,
  }) : super(key: key);

  final Vehicle selectedVehicle;
  final List<Cost> costs;
  final List<CostInfo> costInfo;
  final List<CostInfo> yearCosts;
  final void Function(int, bool)? expandedListener;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SettingsProvider.get(context).preferences;
    print(yearCosts);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
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
                            leading: WidgetUtil.getVehiclePicture(selectedVehicle.imagePath, 90),
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
                              title: ChartTitle(text: "Costs in ${DateFormat("MMMM").format(DateTime.now())}"),
                              legend: Legend(
                                isVisible: true,
                                alignment: ChartAlignment.center,
                                position: LegendPosition.top,
                              ),
                              series: <CircularSeries>[
                                PieSeries<CostInfo, String>(
                                  animationDuration: 700,
                                  dataSource: costInfo.where((element) => element.costName != "Total").toList(),
                                  xValueMapper: (_costInfo, _) => _costInfo.costName,
                                  yValueMapper: (_costInfo, _) => _costInfo.costPrice,
                                  pointColorMapper: (_cost, _) => ColorUtil.getColorBasedOnCostType(_cost.costName),
                                  explode: true,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showZeroValue: false,
                                    labelPosition: ChartDataLabelPosition.outside,
                                    labelIntersectAction: LabelIntersectAction.shift,
                                    useSeriesColor: true,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: yearCosts.isNotEmpty,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelFormat: "{value} ${settings.getCurrency()}",
                                  anchorRangeToVisiblePoints: true,
                                ),
                                series: <ChartSeries>[
                                  ColumnSeries<CostInfo, String>(
                                    borderRadius: InterfaceUtil.topBorderRadius9,
                                    color: mainColor,
                                    dataSource: yearCosts,
                                    xValueMapper: (data, _) => data.costName,
                                    yValueMapper: (data, _) => data.costPrice,
                                    dataLabelMapper: (data, _) => data.costPrice.toString(),
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      useSeriesColor: true,
                                      textStyle: theme.textTheme.displaySmall!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: GroupedListView<Cost, String>(
              elements: costs.toList(),
              groupBy: (cost) => "${DateTime.parse(cost.date).month}",
              order: GroupedListOrder.DESC,
              shrinkWrap: true,
              groupHeaderBuilder: (cost) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 9,
                    left: 16,
                    right: 16,
                  ),
                  child: DateHeaderWidget(
                    cost: cost,
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
                final settings = SettingsProvider.get(context).preferences;
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
                            "Total: ${cost.totalPrice} ${settings.getCurrency()}",
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
                      onTap: () => _editCostNavigate(
                        context,
                        selectedVehicle,
                        cost,
                      ),
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
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
      ),
    );
  }

  _deleteItem(BuildContext context, Cost cost) {
    BlocProvider.of<CostsBloc>(context).add(
      DeleteCost(cost: cost),
    );
  }

  _editCostNavigate(BuildContext context, Vehicle vehicle, Cost cost) {
    final args = AddCostArguments(vehicle: vehicle, cost: cost);

    Navigator.pushNamed(context, AddCostScreen.id, arguments: args);
  }
}

/*
// ONTAP
() => _editCostNavigate(
            context,
            selectedVehicle,
            cost,
          ),
 */

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
