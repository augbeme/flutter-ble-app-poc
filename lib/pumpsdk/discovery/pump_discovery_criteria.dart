
import 'package:flutter_ble_app/pumpsdk/pump/pump_device_type.dart';
import 'package:flutter_ble_app/pumpsdk/pump/pump_service_type.dart';

class PumpDiscoveryCriteria {
  final Set<PumpDeviceType> deviceTypes;
  final Set<PumpServiceType> serviceTypes;
  final Duration timeout;

  PumpDiscoveryCriteria({
    this.deviceTypes = const {PumpDeviceType.tslim, PumpDeviceType.mobi},
    this.serviceTypes = const {PumpServiceType.tips, PumpServiceType.tdu},
    this.timeout = const Duration(seconds: 60),
  });
}
