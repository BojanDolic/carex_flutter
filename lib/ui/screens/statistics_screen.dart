import 'package:carex_flutter/services/bloc/blocs/statistics_bloc.dart';
import 'package:carex_flutter/services/bloc/states/statistics_bloc_states.dart';
import 'package:carex_flutter/services/models/statistic_data.dart';
import 'package:carex_flutter/services/preferences/preferences.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  static const id = "/statistics";

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class ChartData {
  int month;
  int data;

  ChartData(this.month, this.data);
}

late UserPreferences settings;

class _StatisticsScreenState extends State<StatisticsScreen> {
  var fuelRefillsExpanded = false;
  var kilometersExpanded = false;
  var costsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    settings = SettingsProvider.get(context).preferences;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle statistics"),
      ),
      drawer: const CarexDrawer(currentRoute: StatisticsScreen.id),
      body: BlocBuilder<StatisticsBloc, StatisticsBlocStates>(
        builder: (context, state) {
          if (state is StatisticsLoaded) {
            final litersFilledStatistics = state.litersFilledStatistics;
            final summedCostsSixMonths = state.costsSummedSixMonths;
            final kilometersTravelled = state.kilometersTravelledPreviousMonth;
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: InterfaceUtil.allBorderRadius16,
                            child: ExpansionPanelList(
                              expansionCallback: (_, expanded) {
                                setState(() {
                                  fuelRefillsExpanded = !fuelRefillsExpanded;
                                });
                              },
                              expandedHeaderPadding: EdgeInsets.zero,
                              children: [
                                ExpansionPanel(
                                  headerBuilder: (BuildContext context, bool isExpanded) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        "Liters filled this month",
                                      ),
                                    );
                                  },
                                  canTapOnHeader: true,
                                  isExpanded: fuelRefillsExpanded,
                                  body: litersFilledStatistics.isNotEmpty
                                      ? SfCartesianChart(
                                          primaryXAxis: CategoryAxis(
                                            name: "Date",
                                          ),
                                          series: <ChartSeries>[
                                            AreaSeries<StatisticData, String>(
                                              dataSource: litersFilledStatistics,
                                              xValueMapper: (data, _) => DateFormat("MMMM dd").format(DateTime.parse(data.dataName)),
                                              yValueMapper: (data, _) => data.data,
                                              isVisible: true,
                                              borderDrawMode: BorderDrawMode.top,
                                              borderColor: Colors.blue,
                                              borderWidth: 3,
                                              dataLabelSettings: const DataLabelSettings(
                                                isVisible: true,
                                                useSeriesColor: true,
                                              ),
                                            ),
                                          ],
                                          palette: const [
                                            Color(0x5950b4ea),
                                          ],
                                        )
                                      : const Center(
                                          child: Text("No data to show!"),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          ExpandableListHeader(
                            headerText: "Expenses of the previous six months",
                            isExpanded: costsExpanded,
                            onExpanded: (_, __) {
                              setState(() {
                                costsExpanded = !costsExpanded;
                              });
                            },
                            body: summedCostsSixMonths.isNotEmpty
                                ? SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        text: "Total: "
                                            "${summedCostsSixMonths.fold<double>(0, (previousValue, element) => previousValue + element.data)} "
                                            "${settings.getCurrency()}",
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      RadialBarSeries<StatisticData, String>(
                                        dataSource: summedCostsSixMonths,
                                        xValueMapper: (data, _) => data.dataName,
                                        yValueMapper: (data, _) => data.data,
                                        pointColorMapper: (data, _) => ColorUtil.getColorBasedOnCostType(data.dataName),
                                        innerRadius: "30%",
                                        cornerStyle: CornerStyle.endCurve,
                                        trackOpacity: 0.7,
                                        dataLabelSettings: const DataLabelSettings(
                                          isVisible: true,
                                          showZeroValue: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text("No data to show!"),
                                  ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          ExpandableListHeader(
                            headerText: "Kilometers travelled previous month",
                            isExpanded: kilometersExpanded,
                            onExpanded: (_, __) {
                              setState(() {
                                kilometersExpanded = !kilometersExpanded;
                              });
                            },
                            body: kilometersTravelled.data != 0.0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      bottom: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Total: ${kilometersTravelled.data.toInt()} km",
                                        ),
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text("No data to show!"),
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class ExpandableListHeader extends StatelessWidget {
  const ExpandableListHeader({
    Key? key,
    required this.headerText,
    required this.onExpanded,
    required this.isExpanded,
    required this.body,
  }) : super(key: key);

  final String headerText;
  final void Function(int, bool)? onExpanded;
  final bool isExpanded;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: InterfaceUtil.allBorderRadius16,
      child: ExpansionPanelList(
        expansionCallback: onExpanded,
        expandedHeaderPadding: EdgeInsets.zero,
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Text(
                  headerText,
                ),
              );
            },
            canTapOnHeader: true,
            isExpanded: isExpanded,
            body: body,
          ),
        ],
      ),
    );
  }
}
