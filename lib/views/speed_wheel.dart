import 'package:flutter/material.dart';
import 'dart:math';

import '../utils/comm_statu_manager.dart';
import '../utils/ota_data.dart';

class SpeedWheel extends StatefulWidget {
  final void Function(double x, double y) onSpeedChanged;

  const SpeedWheel({Key? key, required this.onSpeedChanged}) : super(key: key);

  @override
  _SpeedWheelState createState() => _SpeedWheelState();
}

class _SpeedWheelState extends State<SpeedWheel> {
  final double _maxSpeed = CommStatusManager().maxSpeed;
  double _currentXSpeed = 0.0;
  double _currentYSpeed = 0.0;
  bool _isActive = false;
  Offset? _pointerPosition;
  double _wheelRadius = 0.0;
  Offset _wheelCenter = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _wheelRadius = min(constraints.maxWidth, constraints.maxHeight) / 2;
        _wheelCenter = Offset(_wheelRadius, _wheelRadius);

        return  GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _handleTouch(details.localPosition),
          onPanUpdate: (details) => _handleTouch(details.localPosition),
          onPanEnd: (_) => _reset(),
          onPanCancel: _reset,
          child: CustomPaint(
            size: Size(_wheelRadius * 2, _wheelRadius * 2),
            painter: _WheelPainter(
              center: _wheelCenter,
              radius: _wheelRadius,
              isActive: _isActive,
              pointerPosition: _pointerPosition,
              xSpeed: _currentXSpeed,
              ySpeed: _currentYSpeed,
              maxSpeed: _maxSpeed,
            ),
          ),
        );
      },
    );
  }

  void _handleTouch(Offset localPosition) {
    // 计算触摸点相对于圆心的偏移量
    final offset = localPosition - _wheelCenter;
    // print('offset=${offset}');
    // print(' offset.distance=${ offset.distance}');

    final distance = offset.distance;

    // 1. 边界检查：如果超出轮盘范围，使用边界点
    bool isInside = distance <= _wheelRadius;
    Offset adjustedPosition = isInside
        ? localPosition
        : _getBoundaryPoint(offset, distance);

    // 2. 计算调整后的偏移量
    final adjustedOffset = adjustedPosition - _wheelCenter;
    final adjustedDistance = adjustedOffset.distance;

    // 3. 转换为自定义坐标系：
    //    X轴：向上为正（屏幕坐标系中Y值减小）
    //    Y轴：向左为正（屏幕坐标系中X值减小）
    final customX = -adjustedOffset.dy; // 向上为正
    final customY = -adjustedOffset.dx; // 向左为正

    // 4. 计算速度比例 (0.0 到 1.0)
    final speedRatio = min(adjustedDistance / _wheelRadius, 1.0);

    // 5. 计算方向向量
    double directionX = 0.0;
    double directionY = 0.0;

    if (adjustedDistance > 0) {
      directionX = customX / adjustedDistance;
      directionY = customY / adjustedDistance;
    }

    // 6. 计算实际速度 (带方向)
    final newXSpeed = directionX * speedRatio * _maxSpeed;
    final newYSpeed = directionY * speedRatio * _maxSpeed;

    setState(() {
      _isActive = true;
      _currentXSpeed = newXSpeed;
      _currentYSpeed = newYSpeed;
      _pointerPosition = adjustedPosition;
    });

    widget.onSpeedChanged(newXSpeed, newYSpeed);
  }

  // 获取边界点（当触摸点超出轮盘时）
  Offset _getBoundaryPoint(Offset offset, double distance) {
    final scale = _wheelRadius / distance;
    return _wheelCenter + offset * scale;
  }

  void _reset() {
    setState(() {
      _isActive = false;
      _currentXSpeed = 0.0;
      _currentYSpeed = 0.0;
      _pointerPosition = null;
    });
    widget.onSpeedChanged(0.0, 0.0);
    CommStatusManager().writerData(setSpeedData(0, 0));

  }
}

class _WheelPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final bool isActive;
  final Offset? pointerPosition;
  final double xSpeed;
  final double ySpeed;
  final double maxSpeed;

  _WheelPainter({
    required this.center,
    required this.radius,
    required this.isActive,
    this.pointerPosition,
    required this.xSpeed,
    required this.ySpeed,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 绘制轮盘背景
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. 绘制刻度环
    final ringPaint = Paint()
      ..color = Colors.blueGrey[300]!
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = 0.25; i < 1.0; i += 0.25) {
      canvas.drawCircle(center, radius * i, ringPaint);
    }

    // 3. 绘制坐标轴
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // X轴（垂直方向，向上为正）
    canvas.drawLine(
      center,
      center + Offset(0, -radius),
      axisPaint,
    );

    // Y轴（水平方向，向左为正）
    canvas.drawLine(
      center,
      center + Offset(-radius, 0),
      axisPaint,
    );

    // 4. 绘制轴标签
    const textStyle = TextStyle(color: Colors.black, fontSize: 12);
    final xLabel = TextPainter(
      text: const TextSpan(text: "X+", style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    xLabel.paint(canvas, center + Offset(-10, -radius - 20));

    final yLabel = TextPainter(
      text: const TextSpan(text: "Y+", style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    yLabel.paint(canvas, center + Offset(-radius - 25, 10));

    // 5. 绘制速度指示器
    final xIndicatorPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0;

    final yIndicatorPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0;

    // X轴指示器（垂直方向）
    final xLength = -xSpeed / maxSpeed * radius; // 注意符号：向上为正
    canvas.drawLine(
      center,
      center + Offset(0, xLength),
      xIndicatorPaint,
    );

    // Y轴指示器（水平方向）
    final yLength = -ySpeed / maxSpeed * radius; // 注意符号：向左为正
    canvas.drawLine(
      center,
      center + Offset(yLength, 0),
      yIndicatorPaint,
    );

    // 6. 绘制触摸点
    if (isActive && pointerPosition != null) {
      final pointerPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pointerPosition!, 12, pointerPaint);
    }

    // 7. 绘制中心原点
    final centerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 使用示例
class SpeedWheelDemo extends StatefulWidget {
  @override
  _SpeedWheelDemoState createState() => _SpeedWheelDemoState();
}

class _SpeedWheelDemoState extends State<SpeedWheelDemo> {
  double _xSpeed = 0.0;
  double _ySpeed = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed Wheel Control')),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        // 速度显示
        Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'X: ${_xSpeed.toStringAsFixed(2)}\nY: ${_ySpeed.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 30),

        // 轮盘控件
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: SpeedWheel(
            onSpeedChanged: (x, y) {
              setState(() {
                _xSpeed = x;
                _ySpeed = y;
              });
            },
          ),
        ),

        const SizedBox(height: 20),

        // 方向说明
        const DirectionInfo(),
        ],
      ),
    ),
    );
  }
}

class DirectionInfo extends StatelessWidget {
  const DirectionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('操作说明:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('• 向上滑动: X轴正方向'),
          Text('• 向下滑动: X轴负方向'),
          Text('• 向左滑动: Y轴正方向'),
          Text('• 向右滑动: Y轴负方向'),
          Text('• 斜向滑动: 同时控制X/Y轴'),
          Text('• 超出圆盘: 保持最大速度'),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: SpeedWheelDemo()));