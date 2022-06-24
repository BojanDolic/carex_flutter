import 'package:carex_flutter/ui/router.dart';
import 'package:carex_flutter/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: MainScreen.id,
      onGenerateRoute: generateRoutes,
    );
  }
}
