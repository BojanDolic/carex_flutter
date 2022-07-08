import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const id = "/mainScreenTest";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentRoute = MyCarScreen.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CarexDrawer(
        currentRoute: MainScreen.id,
      ),
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Text("Dummy data ${index + 1}");
            },
          ),
        ),
      ),
    );
  }
}
