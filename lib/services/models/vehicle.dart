import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle extends Equatable {
  int id = 0;
  bool selected = false;
  String manufacturer = "";
  String model = "";
  int modelYear = 0000;
  int kwPower = 0;
  String? imagePath = "";

  Vehicle({
    this.id = 0,
    this.selected = false,
    this.manufacturer = "Unknown",
    this.model = "Unknown",
    this.modelYear = 0000,
    this.kwPower = 0,
    this.imagePath = "",
  });

  bool get isNewObject => id == 0;

  @override
  List<Object?> get props => [selected, manufacturer, model, modelYear, kwPower, imagePath];

  @override
  String toString() {
    return "{\n"
        "Manufacturer: $manufacturer\n"
        "Image path: $imagePath\n}";
  }
}
