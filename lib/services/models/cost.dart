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

  // For fuel
  double litersFilled;
  double pricePerLiter;

  // For service and maintenance
  List<String> partsChanged;
  List<double> partsPrice;

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
    this.date = "",
    this.time = "",
    this.litersFilled = 0.0,
    this.pricePerLiter = 0.0,
    this.partsChanged = const [],
    this.partsPrice = const [],
  });

  Cost.fuel(
    this.title,
    this.description,
    this.totalPrice,
    this.date,
    this.time,
    this.litersFilled,
    this.pricePerLiter, [
    this.id = 0,
    this.category = "Fuel",
    this.partsChanged = const [],
    this.partsPrice = const [],
  ]);

  Cost.createService(
    this.title,
    this.description,
    this.totalPrice,
    this.date,
    this.time,
    this.partsChanged,
    this.partsPrice, [
    this.id = 0,
    this.pricePerLiter = 0.0,
    this.litersFilled = 0.0,
    this.category = "Service",
  ]);

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
