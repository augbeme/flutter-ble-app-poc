
import 'package:flutter_ble_app/pumpsdk/connection/pump_connection.dart';
import 'package:flutter_ble_app/pumpsdk/discovery/pump_discovery.dart';
import 'package:flutter_ble_app/pumpsdk/manager/pump_init_options.dart';

abstract class PumpManager {
  PumpDiscovery get discovery;

  PumpConnection get connection;
}

class PumpManagerImpl implements PumpManager {
  final PumpDiscovery _discovery;
  final PumpConnection _connection;

  // Constructor that takes PumpInitOptions as a parameter
  PumpManagerImpl({required PumpInitOptions pumpInitOptions})
      : _discovery = PumpDiscoveryImpl(criteria: pumpInitOptions.discoveryCriteria),
        _connection = PumpConnectionImpl();

  @override
  PumpDiscovery get discovery => _discovery;

  @override
  PumpConnection get connection => _connection;
}