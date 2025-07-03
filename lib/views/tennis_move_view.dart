import 'package:flutter/material.dart';

enum Direction { forward, backward, left, right, none }

class DirectionControlPad extends StatelessWidget {
  final Function(Direction) onDirectionChanged;
  final double size;
  final Color backgroundColor;
  final Color buttonColor;
  final Color iconColor;

  const DirectionControlPad({
    Key? key,
    required this.onDirectionChanged,
    this.size = 300,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.buttonColor = const Color(0xFF42A5F5),
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 中央区域
          Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.sports_tennis,
              size: size * 0.15,
              color: Colors.green[800],
            ),
          ),

          // 上方向按钮
          Positioned(
            top: size * 0.1,
            child: _buildDirectionButton(
              icon: Icons.arrow_upward,
              direction: Direction.forward,
            ),
          ),

          // 下方向按钮
          Positioned(
            bottom: size * 0.1,
            child: _buildDirectionButton(
              icon: Icons.arrow_downward,
              direction: Direction.backward,
            ),
          ),

          // 左方向按钮
          Positioned(
            left: size * 0.1,
            child: _buildDirectionButton(
              icon: Icons.arrow_back,
              direction: Direction.left,
            ),
          ),

          // 右方向按钮
          Positioned(
            right: size * 0.1,
            child: _buildDirectionButton(
              icon: Icons.arrow_forward,
              direction: Direction.right,
            ),
          ),
        ],
      ),
    );
  }

  // 构建方向按钮
  Widget _buildDirectionButton({
    required IconData icon,
    required Direction direction,
  }) {
    final buttonSize = size * 0.2;

    return GestureDetector(
      onTapDown: (_) => onDirectionChanged(direction),
      onTapUp: (_) => onDirectionChanged(Direction.none),
      onTapCancel: () => onDirectionChanged(Direction.none),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: buttonSize * 0.6,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}