import 'package:carex_flutter/services/bloc/blocs/costs_bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/ui/screens/add_vehicle_screen.dart';
import 'package:carex_flutter/ui/widgets/heading_container.dart';
import 'package:carex_flutter/util/constants/list_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCostScreen extends StatefulWidget {
  const AddCostScreen({Key? key}) : super(key: key);

  static const id = "/costs/add_cost";

  @override
  State<AddCostScreen> createState() => _AddCostScreenState();
}

class _AddCostScreenState extends State<AddCostScreen> {
  final formKey = GlobalKey<FormState>();

  String? costType;
  final costDescriptionController = TextEditingController();
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

  @override
  void initState() {
    dateController.text = ParserUtil.parseDateISO8601(dateTime);
    timeController.text = ParserUtil.parseTimeISO8601(timeOfDay);

    litersFocus = FocusNode();
    pricePerLiterFocus = FocusNode();
    totalCostFocus = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => saveCost(),
        label: const Text("Save cost"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                              child: GestureDetector(
                                onTap: () async => showDateDialog(),
                                child: InputField(
                                  controller: dateController,
                                  enabled: false,
                                  hint: "Date",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () async => showTimeDialog(),
                                child: InputField(
                                  controller: timeController,
                                  enabled: false,
                                  hint: "Time",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: costType != null && costType == "Service",
                    child: HeadingContainer(
                      headText: "Service",
                      children: [
                        InputField(
                          controller: totalServiceCostController,
                          hint: "Service cost",
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () async => showDateDialog(),
                                child: InputField(
                                  controller: dateController,
                                  enabled: false,
                                  hint: "Date",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () async => showTimeDialog(),
                                child: InputField(
                                  controller: timeController,
                                  enabled: false,
                                  hint: "Time",
                                  keyboardType: TextInputType.number,
                                ),
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
                              parts.add(createPartItem());
                            });
                          },
                          child: Text("Add cost"),
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

  Widget createPartItem() {
    final partNameController = TextEditingController();
    final partPriceController = TextEditingController();

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
                  parts.removeWhere((element) => element.key == key);
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
            trailing: const Text("KM"),
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

  showDateDialog() async {
    final currentDate = DateTime.now();
    final _date = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(currentDate.year),
      lastDate: DateTime.utc(
        currentDate.year + 1,
      ),
    );

    if (_date == null) {
      return;
    }

    setState(() {
      dateTime = _date;
      dateController.text = ParserUtil.parseDateISO8601(_date);
    });
  }

  showTimeDialog() async {
    final _time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (_time == null) {
      return;
    }

    setState(() {
      timeOfDay = _time;
      timeController.text = ParserUtil.parseTimeISO8601(_time);
    });
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
      var cost = Cost();
      if (costType == "Fuel") {
        cost = Cost.fuel(
          "",
          costDescriptionController.text.isEmpty ? "Fuel refill" : costDescriptionController.text,
          double.parse(totalCostController.text),
          dateController.text,
          timeController.text,
          double.parse(litersController.text),
          double.parse(pricePerLiterController.text),
        );
      } else if (costType == "Service") {
        final partsNameList = <String>[];
        final partsPriceList = <double>[];

        for (var i = 0; i < parts.length; i++) {
          partsNameList.add(partsNameEditingControllers[i].text);
          partsPriceList.add(double.parse(partsPriceEditingControllers[i].text));
        }

        cost = Cost.createService(
          "",
          costDescriptionController.text.isEmpty ? "Service" : costDescriptionController.text,
          double.parse(totalServiceCostController.text),
          dateController.text,
          timeController.text,
          partsNameList,
          partsPriceList,
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
    partsPriceEditingControllers.forEach((element) {
      totalPartsPrice += double.parse(element.text);
    });
    setState(() {
      totalServiceCostController.text = totalPartsPrice.toStringAsFixed(2);
    });
  }
}
