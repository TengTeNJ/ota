import 'dart:async';
import 'dart:math';

class LightController {
  static const int lightCount = 8;
  static const int round1LightCount = 1;
  static const int round2LightCount = 2;
  static const int totalActions = 50;
  static const Duration initialDelay = Duration(seconds: 5);
  static const Duration actionDelay = Duration(seconds: 3);

  final List<bool> _lights = List.filled(lightCount, true);
  late Timer _timer;
  int _currentRound = 0;
  int _actionCount = 0;
  List<int> _lastActivated = [];
  final Random _random = Random();

  // 状态变化回调
  final void Function(List<bool> lights) onLightsChanged;
  final void Function(int round, int action) onAction;
  final void Function() onRoundComplete;
  final void Function() onAllRoundsComplete;

  LightController({
    required this.onLightsChanged,
    required this.onAction,
    required this.onRoundComplete,
    required this.onAllRoundsComplete,
  }) {
    _start();
  }

  void _start() {
    // 初始状态：全亮
    _resetAllLights(true);
    _timer = Timer(initialDelay, _startRound1);
  }

  void _startRound1() {
    _currentRound = 1;
    _actionCount = 0;
    _lastActivated = [];
    _executeAction();
  }

  void _startRound2() {
    _currentRound = 2;
    _actionCount = 0;
    _lastActivated = [];
    _executeAction();
  }

  void _executeAction() {
    if (_actionCount >= totalActions) {
      // 当前轮次完成
      _resetAllLights(true);
      onRoundComplete();
      _timer = Timer(initialDelay, () {
        if (_currentRound == 1) {
          _startRound2();
        } else {
          onAllRoundsComplete();
        }
      });
      return;
    }

    _actionCount++;

    // 根据当前轮次点亮相应数量的灯
    final lightsToActivate = _generateUniqueLights(
      count: _currentRound == 1 ? round1LightCount : round2LightCount,
      exclude: _lastActivated,
    );

    // 更新灯光状态
    _resetAllLights(false);
    for (int index in lightsToActivate) {
      _lights[index] = true;
    }

    _lastActivated = lightsToActivate;

    // 通知状态变化
    onLightsChanged(List.from(_lights));
    onAction(_currentRound, _actionCount);

    // 安排下一次动作
    _timer = Timer(actionDelay, _executeAction);
  }

  List<int> _generateUniqueLights({required int count, required List<int> exclude}) {
    final availableIndices = List.generate(lightCount, (i) => i);

    // 移除需要排除的索引（确保相邻两次不同）
    if (exclude.isNotEmpty) {
      availableIndices.removeWhere((index) => exclude.contains(index));
    }

    // 随机选择指定数量的灯
    availableIndices.shuffle(_random);
    return availableIndices.take(count).toList();
  }

  void _resetAllLights(bool value) {
    for (int i = 0; i < lightCount; i++) {
      _lights[i] = value;
    }
  }

  void dispose() {
    _timer.cancel();
  }
}