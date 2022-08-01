import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/vehicle.dart';

class AddCostArguments {
  final Vehicle? vehicle;
  final Cost? cost;

  const AddCostArguments({this.vehicle, this.cost});
}
