enum PumpPairingStatus {
  idle(0),
  readyToEnterPairing(1),
  enteredPairing(2);

  const PumpPairingStatus(this.value);
  
  final int value;

  // Factory method that creates a PumpPairingStatus? from an integer
  static PumpPairingStatus? fromInt(int value) {
    try {
      return PumpPairingStatus.values.firstWhere(
        (status) => status.value == value,
      );
    } catch (e) {
      return null;
    }
  }
}