import 'package:flutter/material.dart';
import 'package:ota/controllers/factory_reset_page.dart';
import 'package:ota/test_controller.dart';

import 'controllers/ota_page.dart';
class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
     FactoryResetPage(),
     const OtaPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_backup_restore),
            label: '出厂设置',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.system_update),
            label: 'OTA升级',
          ),
        ],
      ),
    );
  }
}
