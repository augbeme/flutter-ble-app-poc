import 'package:flutter_ble_app/pumpsdk/utils/advertisement_data_parser.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'pump_state.dart';

class PumpDevice {
  String id;
  String name;
  PumpState state;
  int? rssi;
  BluetoothDevice bluetoothDevice;

  PumpDevice({
    required this.id,
    required this.name,
    required this.state,
    required this.bluetoothDevice,
    required this.rssi,
  });

  // Factory constructor to create a PumpDevice from a ScanResult
  static PumpDevice? fromScanResult(ScanResult result) {
    final parsedData = AdvertisementDataParser.parse(result.advertisementData);

    // Return null if either of parsed data, device type, auth method or pairing status is null
    if (parsedData == null || parsedData.deviceType == null || parsedData.authMethod == null || parsedData.pairingStatus == null) {
      return null;
    }

    // Unwrap the parsed data, ensuring the data is non-optional
    final deviceType = parsedData.deviceType!;
    final authMethod = parsedData.authMethod!;
    final pairingStatus = parsedData.pairingStatus!;

    return PumpDevice(
      id: result.device.remoteId.toString(),
      name: result.device.platformName,
      state: PumpState(authMethod: authMethod, pairingStatus: pairingStatus),
      rssi: result.rssi,
      bluetoothDevice: result.device,
    );
  }

  @override
  String toString() {
    return 'PumpDevice{id: $id, name: $name, state: $state}';
  }
}