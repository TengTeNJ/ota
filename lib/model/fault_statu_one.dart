import 'package:ota/utils/error_dialog.dart';

import '../main.dart';
import 'motor_fault_status.dart';

/// 汇总状态封装类
class DeviceStatus {
  final MotorFaultStatus motorFault;
  final UltrasonicObstacleStatus ultrasonicObstacle;

  DeviceStatus({
    required this.motorFault,
    required this.ultrasonicObstacle,
  });

  factory DeviceStatus.fromBytes(List<int> bytes) {
    if (bytes.length < 2) {
      throw ArgumentError('需要至少两个字节数据');
    }
    return DeviceStatus(
      motorFault: MotorFaultStatus.fromByte(bytes[0]),
      ultrasonicObstacle: UltrasonicObstacleStatus.fromByte(bytes[1]),
    );
  }

  void printSummary() {

    if (!hasAnyAbnormal) {
      print('✅ 设备状态正常，未检测到故障或障碍。');
      return;
    }
    // 弹窗提示
    final context = navigatorKey.currentContext;
    if (context == null) return; // 防止context还未加载完成

    final faults = motorFault.getActiveFaults();
    final warnings = ultrasonicObstacle.getWarnings();
    print('faults=${faults}');
    print('warnings=${warnings}');

    print('--- 电机与系统故障 ---');
    print(faults.isEmpty ? '无故障' : faults.join('、'));

    print('--- 障碍与超声波状态 ---');
    print(warnings.isEmpty ? '无障碍' : warnings.join('、'));

    ErrorDialog.show(context, '${faults.isEmpty ? '' : faults.join('、')}\n${warnings.isEmpty ? '' : warnings.join('、')}');

  }

  /// 是否存在任何异常（包括故障或障碍）
  bool get hasAnyAbnormal => motorFault.hasFault || ultrasonicObstacle.hasWarning;

}
