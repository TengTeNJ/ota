import 'package:flutter/material.dart';
import 'package:ota/utils/comm_statu_manager.dart';

class ErrorDialog {
  static void show(BuildContext context, String message) {
    if(CommStatusManager().hasErrorDialog){
      return;
    }
    CommStatusManager().hasErrorDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Center( // ✅ 整个弹窗水平居中
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center, // ✅ 水平居中
                      children: [
                        const Text(
                          "⚠️ 故障警告",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center, // ✅ 文本水平居中
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: (){
                            CommStatusManager().hasErrorDialog = false;
                            Navigator.of(context).pop();
                          },
                          child: const Text("我知道了"),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 30,
                        child: const Icon(Icons.warning,
                            size: 36, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
