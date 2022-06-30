import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle extends Equatable {
  int id = 0;
  String manufacturer = "";
  String model = "";
  int modelYear = 0000;
  int kwPower = 0;

  Vehicle({
    this.id = 0,
    this.manufacturer = "Unknown",
    this.model = "Unknown",
    this.modelYear = 0000,
    this.kwPower = 0,
  });

  @override
  List<Object?> get props => [manufacturer, model, modelYear, kwPower];
}
