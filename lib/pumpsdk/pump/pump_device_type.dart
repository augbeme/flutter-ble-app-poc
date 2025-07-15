
enum PumpDeviceType {
  tslim(0),
  mobi(1);

  const PumpDeviceType(this.value);
  
  final int value;
  
  // Factory method that creates a PumpDeviceType? from an integer
  static PumpDeviceType? fromInt(int value) {
    try {
      return PumpDeviceType.values.firstWhere(
        (type) => type.value == value,
      );
    } catch (e) {
      return null;
    }
  }
}

