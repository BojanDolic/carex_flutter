import 'package:carex_flutter/objectbox.g.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Cost extends Equatable {
  int id;
  String category;
  String title;
  String description;
  double totalPrice;
  int odometer;

  // For fuel
  double litersFilled;
  double pricePerLiter;

  // For service and maintenance
  List<String> partsChanged;
  List<double> partsPrice;

  List<String> get dbPartsPrice {
    return partsPrice.map((e) => e.toString()).toList();
  }

  set dbPartsPrice(List<String> prices) {
    partsPrice = prices.map((e) => double.parse(e)).toList();
  }

  @Property(uid: 2182237245613617039)
  String date;
  String time;

  final vehicle = ToOne<Vehicle>();

  Cost({
    this.id = 0,
    this.category = "",
    this.title = "",
    this.description = "",
    this.totalPrice = 0.0,
    this.odometer = 0,
    this.date = "",
    this.time = "",
    this.litersFilled = 0.0,
    this.pricePerLiter = 0.0,
    this.partsChanged = const [],
    this.partsPrice = const [],
  });

  Cost.fuel(
    this.id,
    this.title,
    this.description,
    this.totalPrice,
    this.odometer,
    this.date,
    this.time,
    this.litersFilled,
    this.pricePerLiter, [
    this.category = "Fuel",
    this.partsChanged = const [],
    this.partsPrice = const [],
  ]);

  Cost.serviceOrMaintenance(
    this.id,
    this.title,
    this.description,
    this.totalPrice,
    this.odometer,
    this.date,
    this.time,
    this.partsChanged,
    this.partsPrice,
    this.category, [
    this.pricePerLiter = 0.0,
    this.litersFilled = 0.0,
  ]);

  Cost.registration({
    required this.id,
    required this.title,
    required this.description,
    required this.totalPrice,
    required this.odometer,
    required this.date,
    required this.time,
    this.pricePerLiter = 0.0,
    this.litersFilled = 0.0,
    this.partsChanged = const [],
    this.partsPrice = const [],
    this.category = "Registration",
  });

  Cost.parking({
    required this.id,
    required this.title,
    required this.description,
    required this.totalPrice,
    required this.odometer,
    required this.date,
    required this.time,
    this.partsChanged = const [],
    this.partsPrice = const [],
    this.pricePerLiter = 0.0,
    this.litersFilled = 0.0,
    this.category = "Parking",
  });

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        description,
        totalPrice,
        vehicle,
        partsChanged,
        date,
        time,
        litersFilled,
        pricePerLiter,
        partsPrice,
      ];
}
