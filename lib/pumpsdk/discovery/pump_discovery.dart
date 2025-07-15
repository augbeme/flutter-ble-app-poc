
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../discovery/pump_discovery_criteria.dart';

import '../pump/pump_device.dart';
import '../pump/pump_service_type.dart';

abstract class PumpDiscovery {
  Future<Stream<List<PumpDevice>>> startDiscovery();

  Future<void> stopDiscovery();
}

class PumpDiscoveryImpl implements PumpDiscovery {
  PumpDiscoveryCriteria criteria;

  PumpDiscoveryImpl({required this.criteria});

  @override
  Future<Stream<List<PumpDevice>>> startDiscovery() async {
    var servicesToScan = criteria.serviceTypes
      .map((e) => Guid(e.uuid))
      .toList();
    print('Starting discovery for services: $servicesToScan');

    await FlutterBluePlus.startScan(
      withServices: servicesToScan,
      // timeout: criteria.timeout,
      continuousUpdates: true,
    );

    // Listen to scan results and filter based on criteria
    // Map List<ScanResult> to List<PumpDevice>, while discarding nil PumpDevice values
    Stream<List<PumpDevice>> pumpDeviceStream = FlutterBluePlus.scanResults
        .map((results) => results
            .map((result) => PumpDevice.fromScanResult(result))
            .whereType<PumpDevice>()
            .toList());

    return pumpDeviceStream;
  }

  @override
  Future<void> stopDiscovery() async {
    // Implement stop discovery logic here
    FlutterBluePlus.stopScan();
  }
}