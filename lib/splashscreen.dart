import 'dart:async';
import 'buy.dart';
import 'package:flutter/material.dart';

import 'dealerlogin.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var size, height, width;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FifthScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            color: Color(0xFFd81921),
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'images/logos.jpg',
                height: constraints.maxHeight / 0.2,
                width: constraints.maxWidth * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
