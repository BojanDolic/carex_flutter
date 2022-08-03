import 'package:carex_flutter/objectbox.g.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/util/calculator.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBox {
  late final Store store;

  late Box<Vehicle> _vehiclesStore;
  late Box<Cost> _costsStore;

  ObjectBox._create(this.store) {
    _vehiclesStore = store.box<Vehicle>();
    _costsStore = store.box<Cost>();
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  List<Vehicle> getAllNonSelectedVehicles() {
    var vehicles = <Vehicle>[];

    final _queryBuilder = _vehiclesStore.query(Vehicle_.selected.equals(false));

    final _query = _queryBuilder.build();

    vehicles = _query.find();
    _query.close();
    return vehicles;
  }

  // Returns selected vehicle, else returns null
  Vehicle? getSelectedVehicle() {
    final _queryBuilder = _vehiclesStore.query(Vehicle_.selected.equals(true));

    final query = _queryBuilder.build();
    try {
      final vehicle = query.find().first;
      query.close();
      return vehicle;
    } catch (badState) {
      query.close();
      return null;
    }
  }

  List<CostInfo> getYearCostsByMonth() {
    // Current date ex: 2022-07-27
    final currentDate = DateTime.now();
    // Ex 2022-07-27 -> 2022-07-01 / Start of current month
    final currentMonth = DateTime(currentDate.year, currentDate.month);
    // Ex: 2021-07-01
    final dateToQueryFrom = Jiffy(currentMonth).subtract(months: 12).dateTime;

    final selectedVehicle = getSelectedVehicle();
    var costInfo = <CostInfo>[];

    if (selectedVehicle == null) {
      return costInfo;
    }

    final queryBuilder = _costsStore.query(
      Cost_.vehicle.equals(selectedVehicle.id).and(
            Cost_.date
                .greaterThan(
                  ParserUtil.parseDateISO8601(
                    dateToQueryFrom,
                  ),
                )
                .and(
                  Cost_.date.lessThan(
                    ParserUtil.parseDateISO8601(
                      currentMonth,
                    ),
                  ),
                ),
          ),
    )..order(
        Cost_.date,
      );

    final query = queryBuilder.build();

    final costs = query.find();

    final costsMap = <String, double>{};

    costs.forEach((element) {
      final elementDate = DateFormat("MMMM yyyy").format(DateTime.parse(element.date));

      if (costsMap.containsKey(elementDate)) {
        costsMap[elementDate] = costsMap[elementDate]! + element.totalPrice;
      } else {
        costsMap.putIfAbsent(elementDate, () => element.totalPrice);
      }
    });
/*
    for (MapEntry<String, double> entry in costsMap.entries) {
      print("\n[${entry.key}]:[${entry.value}]");
    }*/

    costInfo = costsMap.entries.map((e) => CostInfo(e.key, e.value)).toList();

    query.close();

    //costInfo.addAll(costs.)
    return costInfo;
  }

  List<Cost> getCostsForThisMonth() {
    final vehicle = getSelectedVehicle();
    final currentDate = DateTime.now();
    final thisMonth = DateTime(currentDate.year, currentDate.month);
    var costs = <Cost>[];

    if (vehicle == null) {
      return costs;
    }
    final queryBuilder = _costsStore.query(Cost_.vehicle
        .equals(vehicle.id)
        .and(
          Cost_.date.lessOrEqual(
            ParserUtil.parseDateISO8601(
              currentDate,
            ),
          ),
        )
        .and(Cost_.date.greaterOrEqual(
          ParserUtil.parseDateISO8601(
            thisMonth,
          ),
        )))
      ..order(
        Cost_.date,
        flags: Order.descending,
      );

    final query = queryBuilder.build();

    costs = query.find();
    query.close();
    return costs;
  }

  List<Cost> lastFillups() {
    final vehicle = getSelectedVehicle();
    final currentDate = DateTime.now();
    var costs = <Cost>[];

    if (vehicle == null) {
      return costs;
    }

    final queryBuilder = _costsStore.query(
      Cost_.vehicle.equals(vehicle.id).and(
            Cost_.date
                .lessOrEqual(
                  ParserUtil.parseDateISO8601(
                    currentDate,
                  ),
                )
                .and(
                  Cost_.category.equals("Fuel"),
                ),
          ),
    )
      ..order(
        Cost_.date,
        flags: Order.descending,
      )
      ..order(
        Cost_.time,
        flags: Order.descending,
      );

    final _query = queryBuilder.build();
    _query.limit = 2;

    costs = _query.find();

    _query.close();

    return costs;
  }

  double getAverageFuelConsumption() {
    final vehicle = getSelectedVehicle();
    final currentDate = DateTime.now();
    double average = 0.0;

    if (vehicle == null) {
      return average;
    }

    final queryBuilder = _costsStore.query(
      Cost_.vehicle
          .equals(vehicle.id)
          .and(
            Cost_.date.lessOrEqual(
              ParserUtil.parseDateISO8601(
                currentDate,
              ),
            ),
          )
          .and(
            Cost_.category.equals("Fuel"),
          ),
    )..order(
        Cost_.date,
        flags: Order.descending,
      );

    final _query = queryBuilder.build();
    _query.limit = 2;

    final costs = _query.find();

    if (costs.isEmpty) {
      return average;
    } else if (costs.isNotEmpty && costs.length == 2) {
      average = Calculator.calculateFuelConsumption(costs[0].odometer, costs[1].odometer, costs[1].litersFilled);
    }

    _query.close();

    return average;
  }

  List<CostInfo> getCosts() {
    final List<CostInfo> costInfo = [];
    final currentDate = DateTime.now();
    final vehicle = getSelectedVehicle();

    if (vehicle == null) {
      return costInfo;
    }

    final queryBuilder = _costsStore.query(
      Cost_.vehicle.equals(vehicle.id).and(
            Cost_.date.greaterOrEqual(
              ParserUtil.parseDateISO8601(
                DateTime(currentDate.year, currentDate.month),
              ),
            ),
          ),
    )..order(
        Cost_.date,
        flags: Order.descending,
      );

    final query = queryBuilder.build();

    final costs = query.find();

    var totalCost = 0.0;

    if (costs.isNotEmpty) {
      totalCost = costs.fold(totalCost, (previousValue, element) => previousValue + element.totalPrice);
    }

    costInfo.add(CostInfo("Total", totalCost));
    costInfo.add(
      CostInfo(
        "Fuel",
        costs.fold(
          0,
          (previousValue, element) {
            if (element.category == "Fuel") {
              return previousValue + element.totalPrice;
            } else {
              return previousValue;
            }
          },
        ),
      ),
    );
    costInfo.add(
      CostInfo(
        "Service",
        costs.fold(
          0,
          (previousValue, element) {
            if (element.category == "Service") {
              return previousValue + element.totalPrice;
            } else {
              return previousValue;
            }
          },
        ),
      ),
    );
    costInfo.add(
      CostInfo(
        "Maintenance",
        costs.fold(
          0,
          (previousValue, element) {
            if (element.category == "Maintenance") {
              return previousValue + element.totalPrice;
            } else {
              return previousValue;
            }
          },
        ),
      ),
    );
    costInfo.add(
      CostInfo(
        "Registration",
        costs.fold(
          0,
          (previousValue, element) {
            if (element.category == "Registration") {
              return previousValue + element.totalPrice;
            } else {
              return previousValue;
            }
          },
        ),
      ),
    );
    costInfo.add(
      CostInfo(
        "Parking",
        costs.fold(
          0,
          (previousValue, element) {
            if (element.category == "Parking") {
              return previousValue + element.totalPrice;
            } else {
              return previousValue;
            }
          },
        ),
      ),
    );

    return costInfo;
  }
}
