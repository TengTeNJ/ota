import 'package:flutter/material.dart';

class GlobalAlertManager extends ChangeNotifier {
  static final GlobalAlertManager _instance = GlobalAlertManager._internal();
  factory GlobalAlertManager() => _instance;
  GlobalAlertManager._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context, String message) {
    if (_overlayEntry != null) return; // 已显示则不重复创建

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 禁止交互的遮罩
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning, size: 48, color: Colors.yellow),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
