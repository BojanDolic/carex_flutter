import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle extends Equatable {
  int id;
  bool selected;
  String manufacturer;
  String model;
  String engineDisplacement;
  int modelYear;
  int kwPower;
  String? imagePath;

  Vehicle({
    this.id = 0,
    this.selected = false,
    this.manufacturer = "Unknown",
    this.model = "Unknown",
    this.engineDisplacement = "",
    this.modelYear = 0000,
    this.kwPower = 0,
    this.imagePath = "",
  });

  bool get isNewObject => id == 0;

  @override
  List<Object?> get props => [id, selected, manufacturer, model, engineDisplacement, modelYear, kwPower, imagePath];

  @override
  String toString() {
    return "{\n"
        "Manufacturer: $manufacturer\n"
        "Image path: $imagePath\n}";
  }
}
