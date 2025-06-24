import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:math';
// 标靶数据模型
class Target {
  final int id;           // 标靶ID
  final String type;      // 标靶类型：circle, square, triangle, hexagon
  final Color color;      // 标靶颜色
  bool isVisible;         // 标靶是否可见

  Target({
    required this.id,
    required this.type,
    required this.color,
    this.isVisible = true,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('智能标靶控制系统'),
          leading: Container(
            padding: EdgeInsets.all(8),
            child: Text(
              '组 4027',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
          actions: [
            // 统计信息显示
            TargetStatsWidget(),
            SizedBox(width: 20),
          ],
        ),
        body: TargetControlSystem(),
      ),
    );
  }
}

// 标靶统计信息组件
class TargetStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 这里应该从状态管理中获取实际数据
    final totalTargets = 8;
    final visibleTargets = 5;

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '总标靶数',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              '$totalTargets',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '可见标靶',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              '$visibleTargets',
              style: TextStyle(fontSize: 14, color: Colors.greenAccent),
            ),
          ],
        ),
      ],
    );
  }
}

// 标靶控制系统主组件
class TargetControlSystem extends StatefulWidget {
  @override
  _TargetControlSystemState createState() => _TargetControlSystemState();
}

class _TargetControlSystemState extends State<TargetControlSystem> {
  // 标靶数据列表
  late List<Target> targets;

  @override
  void initState() {
    super.initState();
    // 初始化标靶数据
    targets = [
      Target(id: 1, type: 'circle', color: Colors.green),
      Target(id: 2, type: 'hexagon', color: Colors.yellow),
      Target(id: 3, type: 'circle', color: Colors.lightBlue),
      Target(id: 4, type: 'square', color: Colors.red),
      Target(id: 5, type: 'triangle', color: Colors.green),
      Target(id: 6, type: 'circle', color: Colors.lightBlue),
      Target(id: 7, type: 'hexagon', color: Colors.yellow),
      Target(id: 8, type: 'square', color: Colors.red),
    ];
  }

  // 更新单个标靶可见性
  void updateTargetVisibility(int targetId, bool isVisible) {
    setState(() {
      final target = targets.firstWhere((t) => t.id == targetId);
      target.isVisible = isVisible;
    });
  }

  // 批量更新标靶可见性
  void updateAllTargetsVisibility(bool isVisible) {
    setState(() {
      targets.forEach((t) => t.isVisible = isVisible);
    });
  }

  // 根据数据模拟远程控制指令
  void simulateRemoteControl() {
    // 这里模拟从网络或其他数据源接收指令
    // 实际应用中可能通过WebSocket或API获取数据
    setState(() {
      targets.asMap().forEach((index, target) {
        target.isVisible = index % 2 == 0; // 偶数ID显示，奇数ID隐藏
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 控制面板
        ControlPanel(
          onShowAll: () => updateAllTargetsVisibility(true),
          onHideAll: () => updateAllTargetsVisibility(false),
          onSimulate: simulateRemoteControl,
        ),

        // 标靶显示区域
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final target = targets[index];
                return AnimatedOpacity(
                  opacity: target.isVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Visibility(
                    visible: target.isVisible,
                    child: TargetWidget(
                      target: target,
                      onToggle: () => updateTargetVisibility(target.id, !target.isVisible),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// 控制面板组件
class ControlPanel extends StatelessWidget {
  final VoidCallback onShowAll;
  final VoidCallback onHideAll;
  final VoidCallback onSimulate;

  const ControlPanel({
    Key? key,
    required this.onShowAll,
    required this.onHideAll,
    required this.onSimulate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: onShowAll,
            icon: Icon(Icons.visibility),
            label: Text('显示全部'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onHideAll,
            icon: Icon(Icons.visibility_off),
            label: Text('隐藏全部'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onSimulate,
            icon: Icon(Icons.refresh),
            label: Text('模拟数据'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// 标靶显示组件
class TargetWidget extends StatelessWidget {
  final Target target;
  final VoidCallback onToggle;

  const TargetWidget({
    Key? key,
    required this.target,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '标靶 #${target.id}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              _buildTargetShape(),
              SizedBox(height: 5),
              Text(
                target.isVisible ? '可见' : '隐藏',
                style: TextStyle(
                  fontSize: 10,
                  color: target.isVisible ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 根据类型构建标靶形状
  Widget _buildTargetShape() {
    switch (target.type) {
      case 'circle':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: target.color,
            border: Border.all(color: Colors.black, width: 1),
          ),
        );
      case 'square':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: target.color,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      case 'triangle':
        return ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            width: 50,
            height: 50,
            color: target.color,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        );
      case 'hexagon':
        return ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            width: 50,
            height: 50,
            color: target.color,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        );
      default:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: target.color,
            border: Border.all(color: Colors.black, width: 1),
          ),
        );
    }
  }
}

// 三角形裁剪器（保持不变）
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 六边形裁剪器（保持不变）
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final side = width / 2;
    final offset = height / 2 - side * (math.sqrt(3) / 2);

    path.moveTo(width / 2, 0);
    path.lineTo(width / 2 + side, offset);
    path.lineTo(width / 2 + side, height - offset);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 - side, height - offset);
    path.lineTo(width / 2 - side, offset);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}