import 'package:carex_flutter/ui/screens/costs_screen.dart';
import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/screens/settings_screen.dart';
import 'package:carex_flutter/ui/screens/statistics_screen.dart';
import 'package:carex_flutter/ui/screens/vehicles_screen.dart';
import 'package:carex_flutter/util/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CarexDrawer extends StatelessWidget {
  const CarexDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: mainColorLight,
            ),
            child: Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 64,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  style: ListTileStyle.list,
                  shape: selectedTileShape,
                  title: const Text(
                    "Selected vehicle",
                  ),
                  dense: true,
                  selectedColor: mainColorLight,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  leading: const Icon(Iconsax.category_2),
                  onTap: () => _handleDrawerTap(context, MyCarScreen.id),
                  selected: currentRoute == MyCarScreen.id,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "My vehicles",
                  ),
                  shape: selectedTileShape,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  iconColor: Colors.black,
                  leading: const Icon(Iconsax.car),
                  onTap: () => _handleDrawerTap(context, VehiclesScreen.id),
                  selected: currentRoute == VehiclesScreen.id,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "Costs",
                  ),
                  shape: selectedTileShape,
                  iconColor: Colors.black,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  leading: const Icon(Iconsax.dollar_circle),
                  onTap: () => _handleDrawerTap(context, CostsScreen.id),
                  selected: currentRoute == CostsScreen.id,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "Statistics",
                  ),
                  shape: selectedTileShape,
                  iconColor: Colors.black,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  leading: const Icon(Iconsax.graph4),
                  onTap: () => _handleDrawerTap(context, StatisticsScreen.id),
                  selected: currentRoute == StatisticsScreen.id,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "Gas stations map",
                  ),
                  shape: selectedTileShape,
                  iconColor: Colors.black,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  leading: const Icon(Iconsax.location),
                  onTap: () => _handleDrawerTap(context, CostsScreen.id),
                  selected: currentRoute == CostsScreen.id,
                ),
                const Divider(
                  thickness: 2,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "Settings",
                  ),
                  shape: selectedTileShape,
                  iconColor: Colors.black,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  leading: const Icon(Iconsax.setting4),
                  onTap: () => _handleDrawerTap(context, SettingsScreen.id),
                  selected: currentRoute == SettingsScreen.id,
                ),
                ListTile(
                  style: ListTileStyle.list,
                  title: const Text(
                    "About",
                  ),
                  shape: selectedTileShape,
                  iconColor: Colors.black,
                  dense: true,
                  selectedTileColor: mainColorLight.withOpacity(0.15),
                  selectedColor: mainColorLight,
                  leading: const Icon(Iconsax.info_circle),
                  onTap: () => _handleDrawerTap(context, CostsScreen.id),
                  selected: currentRoute == CostsScreen.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final selectedTileShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
  );

  _handleDrawerTap(BuildContext context, String id) {
    if (id == currentRoute) {
      return;
    }

    Navigator.pop(context);
    if (currentRoute == MyCarScreen.id) {
      Navigator.pushNamed(context, id);
    } else if (currentRoute != MyCarScreen.id && id != MyCarScreen.id) {
      Navigator.pushReplacementNamed(context, id);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, id, (route) => false);
    }
  }
}
