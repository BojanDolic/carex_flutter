import 'package:carex_flutter/main.dart';
import 'package:carex_flutter/ui/router.dart';
import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/screens/vehicles_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const id = "/";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentRoute = MyCarScreen.id;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canPop = navigatorKey.currentState?.canPop();
        if (canPop != null && canPop) {
          navigatorKey.currentState?.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Icon(Icons.directions_car),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                selectedTileColor: Color(0x3DC5DDFF),
                title: Text("Selected vehicle"),
                leading: Icon(Icons.bar_chart),
                onTap: () => _handleDrawerTap(MyCarScreen.id),
                selected: _currentRoute == MyCarScreen.id,
              ),
              ListTile(
                style: ListTileStyle.drawer,
                selectedTileColor: Color(0x3DC5DDFF),
                title: Text("My vehicles"),
                leading: Icon(Icons.car_rental),
                onTap: () => _handleDrawerTap(VehiclesScreen.id),
                selected: _currentRoute == VehiclesScreen.id,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: generateRoutes,
            initialRoute: MyCarScreen.id,
          ),
        ),
      ),
    );
  }

  _handleDrawerTap(String id) {
    setState(() {
      _currentRoute = id;
    });
    Navigator.pop(context);
    navigatorKey.currentState?.pushReplacementNamed(id);
  }
}
