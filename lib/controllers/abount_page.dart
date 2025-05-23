import 'package:flutter/material.dart';




class AboutPage extends StatelessWidget {

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于页面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '版本号: 1.0.0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Build 号: 20230512',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '功能配置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SwitchListTile(
              title: Text('功能开关'),
              value: false, // 示例开关状态
              onChanged: (value) {
                // 示例功能开关逻辑
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}