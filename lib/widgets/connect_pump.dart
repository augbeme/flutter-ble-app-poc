import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../pumpsdk/discovery/pump_discovery_criteria.dart';
import '../pumpsdk/manager/pump_init_options.dart';
import '../pumpsdk/manager/pump_manager.dart';
import '../pumpsdk/pump/pump_device.dart';
import '../pumpsdk/pump/pump_device_type.dart';
import '../pumpsdk/pump/pump_pairing_status.dart';
import '../pumpsdk/pump/pump_service_type.dart';

class ConnectPumpScreen extends StatefulWidget {
  const ConnectPumpScreen({super.key});

  @override
  State<ConnectPumpScreen> createState() => _ConnectPumpScreenState();
}

class _ConnectPumpScreenState extends State<ConnectPumpScreen> {
  List<PumpDevice> _pumpDevices = [];
  PumpDevice? _selectedPumpDevice;
  late StreamSubscription<List<PumpDevice>> _pumpDevicesSubscription;
  final TextEditingController _pairingCodeController = TextEditingController();

  final PumpManager pumpManager = PumpManagerImpl(
    pumpInitOptions: PumpInitOptions(
      discoveryCriteria: PumpDiscoveryCriteria(
        serviceTypes: {PumpServiceType.tips},
        deviceTypes: {PumpDeviceType.mobi, PumpDeviceType.tslim},
        timeout: const Duration(seconds: 4),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connect Pump',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPumpPairingInstructions(),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildPumpPairingTiles(),
          ),
          _buildPumpPairingButton(),
        ],
      ),
    );
  }

  Future onBeginPressed() async {
    // Wait for pump manager discovery stream to stream list of pump devices
    Stream<List<PumpDevice>> pumpDeviceStream = await pumpManager.discovery.startDiscovery();
    _pumpDevicesSubscription = pumpDeviceStream.listen((pumpDevices) {
      setState(() {
        _pumpDevices = pumpDevices;
        print('Discovered pump devices: ${pumpDevices.map((d) => d.name).toList()}');

        // Loop through pumpDevice and select the first one with pairingStatus == readyToEnterPairing
        for (var device in pumpDevices) {
          if (device.state.pairingStatus == PumpPairingStatus.readyToEnterPairing) {
            _selectedPumpDevice = device;
            print('Selected pump device: ${device.name}');
          } else if (device.state.pairingStatus == PumpPairingStatus.enteredPairing) {
            _selectedPumpDevice = device;
            print('Selected pump device entered pairing: ${device.name}');
            pumpManager.discovery.stopDiscovery();
            break;
          }
        }
      });
    });
  }

  // Iterable<Widget> _buildPumpDeviceTiles() {
  //   return _pumpDevices.map((d) => ListTile(
  //         title: Text(d.name),
  //         subtitle: Text('RSSI: ${d.rssi}, ID: ${d.id}'),
  //       ));
  // }

  Widget _buildPumpPairingTiles() {
    if (_selectedPumpDevice == null) {
      return Column(
        children: _pumpDevices.map((d) => ListTile(
          title: Text(d.name),
          subtitle: Text('RSSI: ${d.rssi}, ID: ${d.id}'),
        )).toList(),
      );
    } else {
      switch (_selectedPumpDevice!.state.pairingStatus) {
        case PumpPairingStatus.readyToEnterPairing:
          return ListTile(
            title: Text(_selectedPumpDevice!.name),
            subtitle: Text('Selected!'),
          );
        case PumpPairingStatus.enteredPairing:
          // Return a text field here for entering pairing code
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _pairingCodeController,
              decoration: InputDecoration(
                labelText: 'Enter Pairing Code',
                border: OutlineInputBorder(),
              ),
            ),
          );
        case PumpPairingStatus.idle:
          return SizedBox.shrink();
      }
    }
  }

  Widget _buildPumpPairingInstructions() {
    if (_selectedPumpDevice == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Press "Begin" to start scanning, then place pump on charging pad.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      );
    } else {
      switch (_selectedPumpDevice!.state.pairingStatus) {
        case PumpPairingStatus.readyToEnterPairing:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Great! Now double tap the pump button to enter pairing mode.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          );
        case PumpPairingStatus.enteredPairing:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Pump is in pairing mode. Enter the pairing code displayed on the pump.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          );
        case PumpPairingStatus.idle:
          return SizedBox.shrink();
      }
      
    }
  }

  Widget _buildPumpPairingButton() {
    if (_selectedPumpDevice != null && _selectedPumpDevice!.state.pairingStatus == PumpPairingStatus.enteredPairing) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              onPairPressed();
            },
            child: const Text('Pair'),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            onBeginPressed();
          },
          child: const Text('Begin'),
        ),
      ),
    );
  }

  Future onPairPressed() async {
    final pairingCode = _pairingCodeController.text;
    if (_selectedPumpDevice != null && pairingCode.isNotEmpty) {
      print('Pairing with code: $pairingCode');
      try {
        await pumpManager.connection.connect(_selectedPumpDevice!, pairingCode);
        print('Pump paired successfully!');
      } catch (e) {
        print('Error pairing pump: $e');
      }
    }
  }
}