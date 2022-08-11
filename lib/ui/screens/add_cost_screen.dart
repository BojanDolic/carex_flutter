import 'package:carex_flutter/services/bloc/blocs/costs_bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/preferences/preferences.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/widgets/heading_container.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/list_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCostScreen extends StatefulWidget {
  const AddCostScreen({
    Key? key,
    this.selectedVehicle,
    this.cost,
  }) : super(key: key);

  static const id = "/costs/add_cost";

  final Vehicle? selectedVehicle;
  final Cost? cost;

  @override
  State<AddCostScreen> createState() => _AddCostScreenState();
}

class _AddCostScreenState extends State<AddCostScreen> {
  final formKey = GlobalKey<FormState>();

  String? costType;
  final costDescriptionController = TextEditingController();
  final odometerController = TextEditingController();
  final litersController = TextEditingController();
  final pricePerLiterController = TextEditingController();
  final totalCostController = TextEditingController();
  final totalServiceCostController = TextEditingController();

  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  final dateController = TextEditingController();
  final timeController = TextEditingController();

  late FocusNode litersFocus;
  late FocusNode pricePerLiterFocus;
  late FocusNode totalCostFocus;

  final partsNameEditingControllers = <TextEditingController>[];
  final partsPriceEditingControllers = <TextEditingController>[];
  final parts = <Widget>[];

  Cost cost = Cost();

  bool notifyParking = false;

  late UserPreferences settings;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _cost = widget.cost;
      final _vehicle = widget.selectedVehicle;
      if (_vehicle != null) {
        setState(() {
          odometerController.text = (_vehicle.odometer + 1).toString();
        });
      }
      if (_cost != null) {
        initializeCostData(_cost);
      } else {
        dateController.text = ParserUtil.parseDateISO8601(dateTime);
        timeController.text = ParserUtil.parseTimeISO8601(timeOfDay);
      }
    });

    litersFocus = FocusNode();
    pricePerLiterFocus = FocusNode();
    totalCostFocus = FocusNode();

    super.initState();
  }

  void initializeCostData(Cost cost) {
    setState(() {
      this.cost = cost;
      costType = cost.category;
      dateTime = DateTime.parse(cost.date);
      timeOfDay = TimeOfDay.fromDateTime(DateTime.parse("${cost.date} ${cost.time}"));
      costDescriptionController.text = cost.description;
      dateController.text = ParserUtil.parseDateISO8601(dateTime);
      timeController.text = ParserUtil.parseTimeISO8601(timeOfDay);
      litersController.text = cost.litersFilled.toString();
      pricePerLiterController.text = cost.pricePerLiter.toString();
      totalCostController.text = cost.totalPrice.toString();

      if (cost.partsChanged.isNotEmpty) {
        initializeParts(cost.partsChanged, cost.partsPrice);
      }
    });
  }

  void initializeParts(List<String> partNames, List<double> partPrices) {
    if (partNames.isEmpty) {
      return;
    }
    for (var i = 0; i < partNames.length; i++) {
      parts.add(
        createPartItem(
          partName: partNames[i],
          partPrice: partPrices[i].toString(),
        ),
      );
    }
    calculateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    settings = SettingsProvider.get(context).preferences;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => saveCost(),
        label: const Text("Save cost"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 9,
              bottom: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeadingContainer(
                    headText: "Basic info",
                    children: [
                      DropdownList<String>(
                        hint: "Cost type",
                        items: costTypes,
                        selectedValue: costType,
                        onSelected: (value) {
                          setState(() {
                            costType = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      InputField(
                        controller: costDescriptionController,
                        hint: "Cost description",
                        validator: (text) => ValidatorUtil.validateEmptyText(
                          text,
                          errorMessage: "Cost description can't be empty",
                        ),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      InputField(
                        controller: odometerController,
                        hint: "Odometer",
                        keyboardType: TextInputType.numberWithOptions(signed: true),
                        validator: (text) {
                          if (text != null && text.isNotEmpty && int.parse(text) <= widget.selectedVehicle!.odometer) {
                            return "Odometer value must be greater than previous value";
                          } else if (text == null || text.isEmpty) {
                            return "Odometer field can't be empty!";
                          } else if (text.isNotEmpty && int.parse(text) > widget.selectedVehicle!.odometer) {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: costType != null && costType == "Fuel",
                    child: HeadingContainer(
                      headText: "Fuel cost",
                      children: [
                        InputField(
                          focusNode: litersFocus,
                          controller: litersController,
                          hint: "Liters filled",
                          trailing: const Text("L"),
                          keyboardType: TextInputType.number,
                          onTextChanged: (liters) => parseAndCalculateData(),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        InputField(
                          focusNode: pricePerLiterFocus,
                          controller: pricePerLiterController,
                          hint: "Price per liter",
                          keyboardType: TextInputType.number,
                          onTextChanged: (price) => parseAndCalculateData(),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        InputField(
                          focusNode: totalCostFocus,
                          controller: totalCostController,
                          hint: "Total cost",
                          keyboardType: TextInputType.number,
                          onTextChanged: (totalCost) => parseAndCalculateData(),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: DateField(
                                dateController: dateController,
                                globalDateTime: dateTime,
                                onDatePicked: (DateTime dateTime) {
                                  setState(() {
                                    this.dateTime = dateTime;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: TimeField(
                                timeController: timeController,
                                globalTime: timeOfDay,
                                onTimePicked: (time) {
                                  setState(() {
                                    timeOfDay = time;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: costType != null && (costType == "Service" || costType == "Maintenance"),
                    child: HeadingContainer(
                      headText: "Service",
                      children: [
                        InputField(
                          controller: totalServiceCostController,
                          hint: "Service cost",
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: DateField(
                                dateController: dateController,
                                globalDateTime: dateTime,
                                onDatePicked: (DateTime dateTime) {
                                  setState(() {
                                    this.dateTime = dateTime;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: TimeField(
                                timeController: timeController,
                                globalTime: timeOfDay,
                                onTimePicked: (time) {
                                  setState(() {
                                    timeOfDay = time;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                              child: parts[index],
                            );
                          },
                          itemCount: parts.length,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              parts.add(createPartItem());
                            });
                          },
                          child: Text("Add cost"),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: costType != null && costType == "Parking",
                    child: HeadingContainer(
                      headText: "Parking info",
                      children: [
                        InputField(
                          controller: totalCostController,
                          hint: "Parking price",
                          keyboardType: TextInputType.number,
                          validator: (text) => ValidatorUtil.validateEmptyText(text, errorMessage: "Enter parking fee!"),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: DateField(
                                dateController: dateController,
                                globalDateTime: dateTime,
                                onDatePicked: (date) {
                                  setState(() {
                                    dateTime = date;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: TimeField(
                                timeController: timeController,
                                globalTime: timeOfDay,
                                onTimePicked: (time) {
                                  setState(() {
                                    timeOfDay = time;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        /*Visibility(
                          visible: (dateTime.isAfter(DateTime.now())),
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text("Notify before expiration!"),
                            value: notifyParking,
                            onChanged: (checked) {
                              setState(() {
                                notifyParking = !notifyParking;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Visibility(
                    visible: costType != null && costType == "Registration",
                    child: HeadingContainer(
                      headText: "Parking info",
                      children: [
                        InputField(
                          controller: totalCostController,
                          hint: "Total registration cost",
                          keyboardType: TextInputType.number,
                          validator: (text) => ValidatorUtil.validateEmptyText(text, errorMessage: "You need to enter registration cost!"),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: DateField(
                                dateController: dateController,
                                globalDateTime: dateTime,
                                onDatePicked: (date) {
                                  setState(() {
                                    dateTime = date;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: TimeField(
                                timeController: timeController,
                                globalTime: timeOfDay,
                                onTimePicked: (time) {
                                  setState(() {
                                    timeOfDay = time;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createPartItem({String? partName, String? partPrice}) {
    final partNameController = TextEditingController(text: partName);
    final partPriceController = TextEditingController(text: partPrice);

    partsNameEditingControllers.add(partNameController);
    partsPriceEditingControllers.add(partPriceController);
    final key = UniqueKey();

    return Column(
      key: key,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: InputField(
                controller: partNameController,
                hint: "Part name",
                validator: (text) => ValidatorUtil.validateEmptyText(text, errorMessage: "You need to enter part name!"),
              ),
            ),
            const SizedBox(
              width: 9,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  partsNameEditingControllers.remove(partNameController);
                  partsPriceEditingControllers.remove(partPriceController);
                  parts.removeWhere((element) => element.key == key);
                  calculateTotalPrice();
                });
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 30,
          ),
          child: InputField(
            controller: partPriceController,
            hint: "Part price",
            trailing: Text(settings.getCurrency()),
            validator: (text) => ValidatorUtil.validateEmptyText(text, errorMessage: "Price field can't be empty!"),
            maxLength: 6,
            keyboardType: TextInputType.number,
            onTextChanged: (price) => calculateTotalPrice(),
          ),
        )
      ],
    );
  }

  void parseAndCalculateData() {
    final _fuelPrice = double.tryParse(pricePerLiterController.text);
    final _liters = double.tryParse(litersController.text);
    final _totalCost = double.tryParse(totalCostController.text);

    if (_fuelPrice != null && _liters != null) {
      if (!totalCostFocus.hasFocus) {
        final _totalCostCalculated = _fuelPrice * _liters;
        setState(() {
          totalCostController.text = _totalCostCalculated.toStringAsFixed(2);
        });
        return;
      }
    }
    if (_totalCost != null && _fuelPrice != null) {
      if (!litersFocus.hasFocus) {
        final _litersFilled = _totalCost / _fuelPrice;
        setState(() {
          litersController.text = _litersFilled.toStringAsFixed(2);
        });
        return;
      }
    }
    if (_totalCost != null && _liters != null) {
      if (!pricePerLiterFocus.hasFocus) {
        final _fuelPriceCalculated = _totalCost / _liters;
        setState(() {
          pricePerLiterController.text = _fuelPriceCalculated.toStringAsFixed(3);
        });
        return;
      }
    }
  }

  @override
  void dispose() {
    totalCostFocus.dispose();
    litersFocus.dispose();
    pricePerLiterFocus.dispose();
    super.dispose();
  }

  saveCost() {
    if (formKey.currentState == null) {
      return;
    }

    // Everything is valid inside form
    if (formKey.currentState!.validate()) {
      //var cost = Cost();
      if (costType == "Fuel") {
        cost = Cost.fuel(
          cost.id,
          "",
          costDescriptionController.text.isEmpty ? "Fuel refill" : costDescriptionController.text,
          double.parse(totalCostController.text),
          int.parse(odometerController.text),
          dateController.text,
          timeController.text,
          double.parse(litersController.text),
          double.parse(pricePerLiterController.text),
        );
      } else if (costType == "Service" || costType == "Maintenance") {
        final partsNameList = <String>[];
        final partsPriceList = <double>[];

        for (var i = 0; i < parts.length; i++) {
          partsNameList.add(partsNameEditingControllers[i].text);
          partsPriceList.add(double.parse(partsPriceEditingControllers[i].text));
        }

        cost = Cost.serviceOrMaintenance(
          cost.id,
          "",
          costDescriptionController.text.isEmpty ? "Service" : costDescriptionController.text,
          double.parse(totalServiceCostController.text),
          int.parse(odometerController.text),
          dateController.text,
          timeController.text,
          partsNameList,
          partsPriceList,
          costType!,
        );
      } else if (costType == "Parking") {
        cost = Cost.parking(
          id: cost.id,
          title: "",
          description: costDescriptionController.text,
          totalPrice: double.parse(totalCostController.text),
          odometer: int.parse(odometerController.text),
          date: dateController.text,
          time: timeController.text,
        );
      } else if (costType == "Registration") {
        cost = Cost.registration(
          id: cost.id,
          title: '',
          date: dateController.text,
          time: timeController.text,
          description: costDescriptionController.text,
          totalPrice: double.parse(totalCostController.text),
          odometer: int.parse(odometerController.text),
        );
      }

      BlocProvider.of<CostsBloc>(context).add(
        AddCost(cost: cost),
      );
      Navigator.pop(context);
    }
  }

  void calculateTotalPrice() {
    double totalPartsPrice = 0.0;
    for (var element in partsPriceEditingControllers) {
      if (element.text.isEmpty) {
        continue;
      }
      totalPartsPrice += double.parse(element.text);
    }
    setState(() {
      totalServiceCostController.text = totalPartsPrice.toStringAsFixed(2);
    });
  }
}

class TimeField extends StatelessWidget {
  const TimeField({
    Key? key,
    required this.timeController,
    required this.globalTime,
    required this.onTimePicked,
  }) : super(key: key);

  final TextEditingController timeController;
  final TimeOfDay globalTime;
  final Function(TimeOfDay time) onTimePicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => showTimeDialog(context),
      child: InputField(
        controller: timeController,
        enabled: false,
        hint: "Time",
        keyboardType: TextInputType.number,
      ),
    );
  }

  showTimeDialog(BuildContext context) async {
    final _time = await showTimePicker(
      context: context,
      initialTime: globalTime,
    );

    if (_time == null) {
      return;
    }
    timeController.text = ParserUtil.parseTimeISO8601(_time);
    onTimePicked(_time);
  }
}

class DateField extends StatelessWidget {
  const DateField({
    Key? key,
    required this.dateController,
    required this.globalDateTime,
    required this.onDatePicked,
  }) : super(key: key);

  final TextEditingController dateController;
  final DateTime globalDateTime;
  final Function(DateTime dateTime) onDatePicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => showDateDialog(context),
      child: InputField(
        controller: dateController,
        enabled: false,
        hint: "Date",
        keyboardType: TextInputType.number,
      ),
    );
  }

  showDateDialog(BuildContext context) async {
    final currentDate = DateTime.now();
    final _date = await showDatePicker(
      context: context,
      initialDate: globalDateTime,
      firstDate: DateTime(currentDate.year),
      lastDate: DateTime.utc(
        currentDate.year + 1,
      ),
    );

    if (_date == null) {
      return;
    }
    dateController.text = ParserUtil.parseDateISO8601(_date);

    onDatePicked(_date);
    /*setState(() {
      globalDateTime = _date;

    });*/
  }
}
