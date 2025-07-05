import 'package:flutter/material.dart';

class SpeedPopup {
  static OverlayEntry? _overlayEntry;
  static late AnimationController _controller;
  static late Animation<double> _scaleAnimation;

  static void show(BuildContext context, {required int speed}) {
    // 清除已有显示
    _overlayEntry?.remove();

    // 初始化动画控制器
    _controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // 创建并插入 Overlay
    _overlayEntry = _createOverlayEntry(context, speed);
    Overlay.of(context).insert(_overlayEntry!);

    _controller.forward(from: 0);

    // 自动移除
    Future.delayed(Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _controller.dispose();
    });
  }

  static OverlayEntry _createOverlayEntry(BuildContext context, int speed) {
    return OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${speed} km/h",
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
