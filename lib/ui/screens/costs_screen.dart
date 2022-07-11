import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CostsScreen extends StatefulWidget {
  const CostsScreen({Key? key}) : super(key: key);

  static const id = "/mainScreenTest";

  @override
  State<CostsScreen> createState() => _CostsScreenState();
}

class _CostsScreenState extends State<CostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CarexDrawer(
        currentRoute: CostsScreen.id,
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
