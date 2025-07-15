
import 'package:flutter_ble_app/pumpsdk/pump/pump_device_type.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../pump/pump_pairing_status.dart';
import '../pump/pump_auth_method.dart';

final class AdvertisementDataParser {
  static ParsedAdvertisementData? parse(AdvertisementData data) {
    // Parse the advertisement data here
    
    // Return null if data.manufacturerData is empty OR doesn't contain Tandem's manufacturerID code: 0x059D (0x9D05 in little-endian)
    if (data.manufacturerData.isEmpty) {
      return null;
    }
    if (!data.manufacturerData.containsKey(0x059D)) {
      return null;
    }
    final manufacturerData = data.manufacturerData[0x059D] ?? [];

    // Return null if manufacturerData is empty OR has less than 3 bytes
    if (manufacturerData.isEmpty || manufacturerData.length < 3) {
      return null;
    }

    // Device type and discovery state are shared in the 3rd byte (index 2)
    final deviceTypeAndDiscoveryState = manufacturerData[2];

    // Extract device type (upper 4 bits) and discovery state (lower 4 bits)
    final deviceTypeValue = (deviceTypeAndDiscoveryState & 0xF0) >> 4;
    final discoveryStateValue = deviceTypeAndDiscoveryState & 0x0F;
    final deviceType = PumpDeviceType.fromInt(deviceTypeValue);
    final pairingStatus = PumpPairingStatus.fromInt(discoveryStateValue);

    print('Pairing Status: $pairingStatus');

    // Extract API version from the 2nd byte (index 1)
    final apiVersion = manufacturerData[1];

    print('Device Name: ${data.advName}');
    print('Service UUIDs: ${data.serviceUuids}');
    print('Manufacturer Data: ${data.msd}');
    print('Service Data: ${data.serviceData}');
    print('Tx Power Level: ${data.txPowerLevel}');

    return ParsedAdvertisementData(
      apiVersion: apiVersion,
      pairingStatus: pairingStatus,
      authMethod: PumpAuthMethod.fromInt(apiVersion),
      deviceType: deviceType,
    );
  }
}

class ParsedAdvertisementData {
  final int apiVersion;
  PumpPairingStatus? pairingStatus;
  PumpAuthMethod? authMethod;
  PumpDeviceType? deviceType;

  ParsedAdvertisementData({
    required this.apiVersion,
    required this.pairingStatus,
    required this.authMethod,
    required this.deviceType,
  });

  @override
  String toString() {
    return 'ParsedAdvertisementData{apiVersion: $apiVersion, pairingStatus: $pairingStatus, authMethod: $authMethod, deviceType: $deviceType}';
  }
}