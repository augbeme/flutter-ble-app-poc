import 'pump_auth_method.dart';
import 'pump_pairing_status.dart';

class PumpState {
  PumpPairingStatus pairingStatus;
  PumpAuthMethod authMethod;

  PumpState({
    required this.pairingStatus,
    required this.authMethod,
  });
}