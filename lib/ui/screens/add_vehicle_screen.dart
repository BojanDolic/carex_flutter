import 'dart:io';

import 'package:carex_flutter/services/bloc/events/vehicles_bloc_events.dart';
import 'package:carex_flutter/services/bloc/vehicles_bloc.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/ui/widgets/heading_container.dart';
import 'package:carex_flutter/util/constants/color_constants.dart';
import 'package:carex_flutter/util/constants/list_constants.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({
    Key? key,
    this.vehicle,
  }) : super(key: key);

  static const id = "/vehicles/add_vehicle";
  final Vehicle? vehicle;

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  String? manufacturer;
  String? _engineDisplacement;
  String? modelYear;
  String? fuelType;

  final modelNameController = TextEditingController();
  final enginePowerController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;

  final _formKey = GlobalKey<FormState>();

  Vehicle _vehicle = Vehicle();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.vehicle != null) {
        _loadData(widget.vehicle!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicle != null ? _vehicle.model : "Add new vehicle",
        ),
        actions: [
          IconButton(
            onPressed: () => _addVehicleToDatabase(),
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  HeadingContainer(
                    headText: "Basic information",
                    children: [
                      GestureDetector(
                        onTap: () => _handleImagePick(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: pickedImage != null
                              ? Image.file(
                                  File(pickedImage?.path ?? ""),
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.photo,
                                          size: 42,
                                        ),
                                        Text(
                                          "(Optional)",
                                          style: textTheme.displaySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      DropdownList<String>(
                        hint: "Manufacturer",
                        items: getManufacturers(),
                        validator: (manufacturer) => ValidatorUtil.validateEmptyText(
                          manufacturer,
                          errorMessage: "You need to select car manufacturer!",
                        ),
                        selectedValue: manufacturer,
                        onSelected: (item) {
                          setState(() {
                            manufacturer = item;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputField(
                        controller: modelNameController,
                        hint: "Model name",
                        textInputAction: TextInputAction.next,
                        validator: (text) => ValidatorUtil.validateEmptyText(
                          text,
                          errorMessage: "Model name can't be empty!",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  HeadingContainer(
                    headText: "Vehicle data",
                    children: [
                      DropdownList<String>(
                          hint: "Engine displacement",
                          items: getEngineDisplacements(),
                          selectedValue: _engineDisplacement,
                          validator: (displacement) => ValidatorUtil.validateEmptyText(
                                displacement,
                                errorMessage: "You need to select engine displacement",
                              ),
                          onSelected: (displacement) => {
                                setState(() {
                                  _engineDisplacement = displacement;
                                })
                              }),
                      const SizedBox(
                        height: 12,
                      ),
                      InputField(
                        controller: enginePowerController,
                        hint: "Engine power (kW)",
                        maxLength: 3,
                        textInputAction: TextInputAction.done,
                        validator: (text) {
                          if (text != null && text.isNotEmpty && int.parse(text) > 0) {
                            return null;
                          } else {
                            return "Engine power can't be smaller than 1kW";
                          }
                        },
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        textFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      DropdownList<String>(
                        hint: "Model year",
                        items: getModelYears(),
                        selectedValue: modelYear,
                        validator: (year) => ValidatorUtil.validateEmptyText(
                          year,
                          errorMessage: "You need to select model year!",
                        ),
                        onSelected: (year) {
                          setState(() {
                            modelYear = year;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      DropdownList<String>(
                        hint: "Fuel type",
                        items: fuelTypes,
                        selectedValue: fuelType,
                        onSelected: (fuel) {
                          setState(() {
                            fuelType = fuel;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleImagePick() {
    showModalBottomSheet(
      shape: InterfaceUtil.topCornerRoundedRectangle16,
      context: context,
      builder: (context) {
        return BottomSheet(
          shape: InterfaceUtil.topCornerRoundedRectangle16,
          onClosing: () {},
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Take a picture"),
                  onTap: () async {
                    Navigator.pop(context);
                    _takePictureFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text("Pick from gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  _pickImageFromGallery() async {
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  _takePictureFromCamera() async {
    final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  _addVehicleToDatabase() {
    if (_formKey.currentState == null) {
      return;
    }
    if ((_formKey.currentState?.validate())!) {
      _parseData();
    } else {
      SnackBarUtil.showInfoSnackBar(context, "Check your input fields!");
    }
  }

  void _parseData() {
    final _modelName = modelNameController.text;
    final _enginePower = int.parse(enginePowerController.text);
    final _manufacturer = manufacturer!;
    final _displacement = _engineDisplacement!;
    final _modelYear = int.parse(modelYear!);
    final imagePath = pickedImage?.path;
    final _fuelType = fuelType!;

    if (_vehicle.isNewObject) {
      _vehicle = Vehicle(
        model: _modelName,
        manufacturer: _manufacturer,
        imagePath: imagePath,
        kwPower: _enginePower,
        modelYear: _modelYear,
        engineDisplacement: _displacement,
        fuelType: _fuelType,
      );
    } else {
      _vehicle = Vehicle(
        id: _vehicle.id,
        model: _modelName,
        manufacturer: _manufacturer,
        imagePath: imagePath,
        kwPower: _enginePower,
        modelYear: _modelYear,
        engineDisplacement: _displacement,
        selected: _vehicle.selected,
        fuelType: _fuelType,
      );
    }

    _insertVehicle(_vehicle);
  }

  void _insertVehicle(Vehicle vehicle) {
    BlocProvider.of<VehiclesBloc>(context).add(
      AddVehicle(vehicle: vehicle),
    );

    Navigator.pop(context);
  }

  void _loadData(Vehicle vehicle) {
    setState(() {
      _vehicle = vehicle;
      enginePowerController.text = _vehicle.kwPower.toString();
      modelNameController.text = _vehicle.model;
      manufacturer = _vehicle.manufacturer;
      _engineDisplacement = _vehicle.engineDisplacement;
      modelYear = _vehicle.modelYear.toString();
      pickedImage = _vehicle.imagePath != null ? XFile(_vehicle.imagePath!) : null;
      fuelType = _vehicle.fuelType == "" ? null : _vehicle.fuelType;
    });
  }
}

class DropdownList<T> extends StatelessWidget {
  const DropdownList({
    Key? key,
    required this.hint,
    required this.items,
    required this.onSelected,
    this.selectedValue,
    this.borderRadius,
    this.validator,
  }) : super(key: key);

  final String hint;
  final List<T> items;
  final dynamic Function(T?)? onSelected;
  final String? Function(T?)? validator;
  final T? selectedValue;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dropdownColor: Colors.white,
      style: theme.textTheme.bodyMedium,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: mainColor,
      ),
      isExpanded: true,
      hint: Text(
        hint,
        style: theme.textTheme.bodyMedium,
      ),
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          child: Text(item.toString()),
          value: item,
        );
      }).toList(),
      onChanged: onSelected,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12,
          ),
        ),
      ),
    );
  }
}
/*
borderRadius: BorderRadius.circular(12),
        underline: Container(),
 */

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.borderRadius,
    required this.hint,
    this.keyboardType,
    this.onTextChanged,
    this.textFormatters,
    this.validator,
    this.maxLength,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  final double? borderRadius;
  final String hint;
  final TextInputType? keyboardType;
  final Function(String)? onTextChanged;
  final List<TextInputFormatter>? textFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return TextFormField(
      controller: controller,
      cursorColor: theme.primaryColor,
      style: textTheme.bodyMedium,
      keyboardType: keyboardType,
      inputFormatters: textFormatters,
      onChanged: onTextChanged,
      validator: validator,
      maxLength: maxLength,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12,
          ),
        ),
        labelStyle: textTheme.bodyMedium,
        floatingLabelStyle: theme.inputDecorationTheme.floatingLabelStyle,
        labelText: hint,
      ),
    );
  }
}
