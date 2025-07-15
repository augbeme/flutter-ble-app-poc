import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble_app/widgets/connect_pump.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> stateSubscription;

  @override
  void initState() {
    super.initState();
    stateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        adapterState = state;
      });
    });
  }

  @override
  void dispose() {
    stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = const ConnectPumpScreen();
  
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: screen,
    );
  }
}
