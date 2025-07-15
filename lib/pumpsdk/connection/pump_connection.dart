
import 'dart:async';

import '../pump/pump_device.dart';

enum PumpConnectionState {
  idle,
  establishingCommunication,
  readyToCommunicate,
}

abstract class PumpConnection {
  Stream<PumpConnectionState> get connectionStateStream;
  Future<void> connect(PumpDevice device, String passcode);
  Future<void> disconnect();
}

class PumpConnectionImpl implements PumpConnection {
  final _connectionStateController = StreamController<PumpConnectionState>();

  @override
  Stream<PumpConnectionState> get connectionStateStream => _connectionStateController.stream;

  @override
  Future<void> connect(PumpDevice device, String passcode) async {
    _connectionStateController.add(PumpConnectionState.establishingCommunication);
    await device.bluetoothDevice.connect(mtu: null);
    _connectionStateController.add(PumpConnectionState.readyToCommunicate);
  }

  @override
  Future<void> disconnect() async {
    _connectionStateController.add(PumpConnectionState.idle);
  }
}
