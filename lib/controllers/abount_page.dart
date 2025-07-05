import 'package:flutter/material.dart';
import 'package:ota/controllers/power_page.dart';
import 'package:ota/controllers/target_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../utils/system_util.dart';
import '../utils/theme_provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo packageInfo = PackageInfo(
  appName: '网球训练机器人',
  packageName: 'com.potent.ota',
  version: '1.0',
  buildNumber: '1');
  int _currentValue = 2;

  fetchApplicationInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  setState(() {
    packageInfo = _packageInfo;
  });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchApplicationInfo();
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(182, 246, 29, 1.0),
          centerTitle: true,
          title: Text(
            '设置',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '版本号: ${packageInfo.version}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Build 号:  ${packageInfo.buildNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '功能配置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SwitchListTile(
            contentPadding:EdgeInsets.zero,
              title: Text('暗黑模式'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('设置最大速度: ${CommStatusManager().maxSpeed}',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                NumberPicker(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: CommStatusManager().maxSpeed.toInt(),
                  minValue: 1,
                  maxValue: 10,
                  step: 1,
                  onChanged: (value) {
                    setState(() {
                      CommStatusManager().maxSpeed = value.toDouble();
                      _currentValue = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('设置标靶时间间隔: ${CommStatusManager().targetInteral}秒',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                NumberPicker(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: CommStatusManager().targetInteral,
                  minValue: 1,
                  maxValue: 20,
                  step: 1,
                  onChanged: (value) {
                    setState(() {
                      CommStatusManager().targetInteral = value.toInt();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                SystemUtil.lockScreenHorizontalDirection();
                Future.delayed(Duration(milliseconds: 500),(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>TargetPage()), // 目标页面
                  );
                });
              },
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('标靶训练',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(width: 2,),
                    Icon(Icons.track_changes)
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 16)
              ],
            ),),
            SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                SystemUtil.lockScreenHorizontalDirection();
                Future.delayed(Duration(milliseconds: 500),(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>PowerPage()), // 目标页面
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('力量训练',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(width: 2,),
                      Icon(Icons.track_changes)
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16)
                ],
              ),),
          ],
        ),
      ),
    );
  }
}


