import 'package:flutter/material.dart';

enum ServeType {
  leftHigh,   // 左高
  leftLow,    // 左低
  rightHigh,  // 右高
  rightLow,   // 右低
}

class ServeTypeController extends StatelessWidget {
  final Function(ServeType) onServeTypeChanged;
  final ServeType? selectedType;

  const ServeTypeController({
    Key? key,
    required this.onServeTypeChanged,
    this.selectedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '发球类型',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 方向和高度标签
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('左', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 100),
              Text('右', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 10),

          // 2x2 网格布局
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              // 左上：左高
              _buildServeTypeButton(
                serveType: ServeType.leftHigh,
                icon: Icons.arrow_upward,
                label: '高球',
                isSelected: selectedType == ServeType.leftHigh,
              ),

              // 右上：右高
              _buildServeTypeButton(
                serveType: ServeType.rightHigh,
                icon: Icons.arrow_upward,
                label: '高球',
                isSelected: selectedType == ServeType.rightHigh,
              ),

              // 左下：左低
              _buildServeTypeButton(
                serveType: ServeType.leftLow,
                icon: Icons.arrow_downward,
                label: '低球',
                isSelected: selectedType == ServeType.leftLow,
              ),

              // 右下：右低
              _buildServeTypeButton(
                serveType: ServeType.rightLow,
                icon: Icons.arrow_downward,
                label: '低球',
                isSelected: selectedType == ServeType.rightLow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建发球类型按钮
  Widget _buildServeTypeButton({
    required ServeType serveType,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onServeTypeChanged(serveType),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? Colors.lightBlue : Colors.grey[200],
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}