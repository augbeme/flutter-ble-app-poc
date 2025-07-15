
enum PumpServiceType {
  tips,
  tdu,
}

extension PumpServiceTypeExtension on PumpServiceType {
  String get uuid {
    switch (this) {
      case PumpServiceType.tips:
        return 'FDFB';
      case PumpServiceType.tdu:
        return 'FDFA';
    }
  }
}