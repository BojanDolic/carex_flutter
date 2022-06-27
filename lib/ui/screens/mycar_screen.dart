import 'package:flutter/material.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  static const id = "/";

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text("Title dialog"),
                ),
              );
            },
            child: Text(
              "Home page my car screen",
            ),
          ),
        ),
      ),
    );
  }
}
