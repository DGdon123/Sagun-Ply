import 'package:ecommerce/buy.dart';

import 'package:ecommerce/data_class.dart';
import 'package:ecommerce/dealerlogin.dart';
import 'package:ecommerce/help.dart';
import 'package:ecommerce/order.dart';
import 'package:ecommerce/orderplacement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

import 'cart_provider.dart';
import 'checkout.dart';
import 'dealer.dart';

import 'invoice.dart';
import 'orderdetails.dart';
import 'splashscreen.dart';
import 'profile.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DataClass()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Start the app with the "/" named route. In this case, the app starts
        // on the FirstScreen widget.
        initialRoute: '/',
        routes: {
          // When navigating to the "/" routes, build the FirstScreen widget.
          '/': (context) => const MyHomePage(),
          '/second': (context) => const FirstScreen(),
          '/third': (context) => const FifthScreen(),
          '/fourth': (context) => const FourthScreen(),
          '/fifth': (context) => const SixthScreen(),
          '/sixth': (context) => SixthRoute(
                index: 0,
                ring: const [],
              ),
          '/seventh': (context) => const SeventhScreen(),
          '/eighth': (context) => const FourthRoute(),
          '/tenth': (context) => const EighthScreen(),
          '/eleventh': (context) => const EighthRoute(),
          '/tweleventh': (context) => const NinethRoute(),
          '/thirteenth': (context) => TenthRoute(
                index: 0,
                ring: const [],
              ),
        },
      ),
    );
  }
}
