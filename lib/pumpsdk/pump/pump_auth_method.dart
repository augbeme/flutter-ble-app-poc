enum PumpAuthMethod {
  legacy(0),
  jpake(1);

  const PumpAuthMethod(this.value);
  
  final int value;

  // Factory method that creates a PumpAuthMethod? from an integer
  static PumpAuthMethod? fromInt(int value) {
    try {
      return PumpAuthMethod.values.firstWhere(
        (method) => method.value == value,
      );
    } catch (e) {
      return null;
    }
  }
}
