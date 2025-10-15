import 'dart:async';

import 'package:event_bus/event_bus.dart';

import '../../../constants.dart';
import '../../../utils/comm_statu_manager.dart';
import '../../../utils/event_manager.dart';
import '../../../utils/ota_data.dart';
import '../../step_control_page.dart';

// 定义任务结构
class FireTask {
  final int count; // 发球数量
  final TennisMachineParams params; // 点位参数
  FireTask({required this.count, required this.params});
}

// 定义一个发球控制器
class FireController {
  final List<FireTask> tasks;
  int _currentTaskIndex = 0;
  int _currentShot = 0;
  late StreamSubscription _subscription;

  Function()? onFinished; // 全部任务完成回调
  Function(int taskIndex, int shotIndex)? onProgress; // 进度回调

  FireController(this.tasks);

  void start() {
    // 监听 EventBus
    EventBus eventBus = EventBusManager().eventBus;

    _subscription = eventBus.on<DataUpdatedEvent>().listen((event){
      if (event.data == kStepControlFinishResponse) {
        // 收到回复
        _handleSuccess();
      }
    });
    _currentTaskIndex = 0;
    _currentShot = 0;
    _fireNext();
  }

  void _handleSuccess() {
    if(_currentTaskIndex >= tasks.length){
      print('_currentTaskIndex = ${_currentTaskIndex}');
      return;
    }
    final task = tasks[_currentTaskIndex];

    _currentShot++;
    onProgress?.call(_currentTaskIndex, _currentShot);

    if (_currentShot < task.count) {
      // 同一个点位还没完成，继续发
      _fireNext();
    } else {
      // 切换下一个点位
      _currentTaskIndex++;
      _currentShot = 0;
      _fireNext();
    }
  }

  void _fireNext() {
    if (_currentTaskIndex >= tasks.length) {
      onFinished?.call();
      return;
    }
    final task = tasks[_currentTaskIndex];
    final params = task.params;
    // 发球命令
    CommStatusManager().writerData(stepControlData(params));
  }

  bool _isSuccess(dynamic reply) {
    // 解析设备回复，这里简单写
    return true;
  }
}
