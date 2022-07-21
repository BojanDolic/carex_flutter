import 'package:carex_flutter/services/models/cost.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle extends Equatable {
  int id;
  bool selected;
  String manufacturer;
  String model;
  String engineDisplacement;
  String fuelType;
  int modelYear;
  int kwPower;
  String? imagePath;

  @Backlink("vehicle")
  final costs = ToMany<Cost>();

  Vehicle({
    this.id = 0,
    this.selected = false,
    this.manufacturer = "Unknown",
    this.model = "Unknown",
    this.engineDisplacement = "",
    this.fuelType = "",
    this.modelYear = 0000,
    this.kwPower = 0,
    this.imagePath = "",
  });

  bool get isNewObject => id == 0;

  @override
  List<Object?> get props => [id, selected, manufacturer, model, engineDisplacement, fuelType, modelYear, kwPower, imagePath, costs];

  @override
  String toString() {
    return "{\n"
        "Manufacturer: $manufacturer\n"
        "Image path: $imagePath\n}";
  }
}
