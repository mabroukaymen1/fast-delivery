import 'package:flutter/material.dart';
import 'package:fuck/home/home.dart';
import 'package:fuck/home/order/checkout.dart';
import 'package:fuck/home/order/payment.dart';
import 'package:fuck/home/search.dart';
import 'package:fuck/home/order/location.dart';
import 'package:fuck/step/welcome.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DetailCheckoutPage(),
    );
  }
}
