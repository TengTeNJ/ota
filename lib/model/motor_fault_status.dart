/// 电机与系统故障状态（Byte1）
class MotorFaultStatus {
  final bool turntableMotorBlocked;  // Bit[0]
  final bool noBall;                 // Bit[1]
  final bool undervoltage;           // Bit[2]
  final bool motorAFault;            // Bit[3]
  final bool motorBFault;            // Bit[4]
  final bool motorCFault;            // Bit[5]
  final bool motorDFault;            // Bit[6]
  final bool ballChannelBlocked;     // Bit[7]

  MotorFaultStatus({
    required this.turntableMotorBlocked,
    required this.noBall,
    required this.undervoltage,
    required this.motorAFault,
    required this.motorBFault,
    required this.motorCFault,
    required this.motorDFault,
    required this.ballChannelBlocked,
  });

  factory MotorFaultStatus.fromByte(int byte) {
    return MotorFaultStatus(
      turntableMotorBlocked: (byte & 0x01) != 0,
      noBall:                (byte & 0x02) != 0,
      undervoltage:          (byte & 0x04) != 0,
      motorAFault:           (byte & 0x08) != 0,
      motorBFault:           (byte & 0x10) != 0,
      motorCFault:           (byte & 0x20) != 0,
      motorDFault:           (byte & 0x40) != 0,
      ballChannelBlocked:    (byte & 0x80) != 0,
    );
  }

  List<String> getActiveFaults() {
    final faults = <String>[];
    if (turntableMotorBlocked) faults.add('转盘电机堵转故障');
    if (noBall) faults.add('无球故障');
    if (undervoltage) faults.add('欠压');
    if (motorAFault) faults.add('底盘电机A故障');
    if (motorBFault) faults.add('底盘电机B故障');
    if (motorCFault) faults.add('底盘电机C故障');
    if (motorDFault) faults.add('底盘电机D故障');
    if (ballChannelBlocked) faults.add('通道堵球故障');
    return faults;
  }

  /// 是否存在任意故障
  bool get hasFault => getActiveFaults().isNotEmpty;
}

/// 障碍物与超声波模块状态（Byte2）
class UltrasonicObstacleStatus {
  final bool frontObstacle;   // Bit[0]
  final bool rearObstacle;    // Bit[1]
  final bool leftObstacle;    // Bit[2]
  final bool rightObstacle;   // Bit[3]
  final bool frontUltrasonicFault;  // Bit[4]
  final bool rearUltrasonicFault;   // Bit[5]
  final bool leftUltrasonicFault;   // Bit[6]
  final bool rightUltrasonicFault;  // Bit[7]

  UltrasonicObstacleStatus({
    required this.frontObstacle,
    required this.rearObstacle,
    required this.leftObstacle,
    required this.rightObstacle,
    required this.frontUltrasonicFault,
    required this.rearUltrasonicFault,
    required this.leftUltrasonicFault,
    required this.rightUltrasonicFault,
  });

  factory UltrasonicObstacleStatus.fromByte(int byte) {
    return UltrasonicObstacleStatus(
      frontObstacle:          (byte & 0x01) != 0,
      rearObstacle:           (byte & 0x02) != 0,
      leftObstacle:           (byte & 0x04) != 0,
      rightObstacle:          (byte & 0x08) != 0,
      frontUltrasonicFault:   (byte & 0x10) != 0,
      rearUltrasonicFault:    (byte & 0x20) != 0,
      leftUltrasonicFault:    (byte & 0x40) != 0,
      rightUltrasonicFault:   (byte & 0x80) != 0,
    );
  }

  List<String> getWarnings() {
    final warnings = <String>[];
    if (frontObstacle) warnings.add('前方存在障碍物');
    if (rearObstacle) warnings.add('后方存在障碍物');
    if (leftObstacle) warnings.add('左方存在障碍物');
    if (rightObstacle) warnings.add('右方存在障碍物');
    if (frontUltrasonicFault) warnings.add('前超声波超时故障');
    if (rearUltrasonicFault) warnings.add('后超声波超时故障');
    if (leftUltrasonicFault) warnings.add('左超声波超时故障');
    if (rightUltrasonicFault) warnings.add('右超声波超时故障');
    return warnings;
  }

  /// 是否存在障碍或超声波故障
  bool get hasWarning => getWarnings().isNotEmpty;
}
