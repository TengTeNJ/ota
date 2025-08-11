// lib/language/language_model.dart
import 'package:flutter/material.dart';

class LanguageModel extends ChangeNotifier {
  // 默认中文
  Locale _currentLocale = const Locale('en');

  // 支持的语言列表
  final Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      '烧录': '烧录',
      'OTA升级': 'OTA升级',
      '设备': '设备',
      '更多': '更多',
      '重新搜索': '重新搜索',
      '版本号': '版本号',
      'Build号': 'Build号',
      '功能配置': '功能配置',
      '最大移动速度': '最大移动速度',
      '标靶时间间隔': '标靶时间间隔',
      '标靶训练': '标靶训练',
      '力量训练': '力量训练',
      '语言切换': '语言切换',
      '蓝牙1': '确保蓝牙已开启，并且设备处于可发现状态',
      '蓝牙2': '确保已开启定位服务（Android 6.0 及以上设备需要此权限才能搜索蓝牙设备）',
      '蓝牙2iOS': '确保已开启定位服务（iOS 13 及以上版本需要此权限才能使用蓝牙功能',
      '蓝牙3': '确保设备在扫描范围内，并且没有被其他设备连接',
      '设备列表': '设备列表',
      '连接': '连接',
      '断开连接': '断开连接',
      '移动发球': '移动发球',
      '调节发球': '调节发球',
      '手动遥控': '手动遥控',
      '正在更新最新固件程序...': '正在更新最新固件程序...',
      '更新下载最新的固件成功': '更新下载最新的固件成功',
      '更新下载最新的固件失败，使用本地默认固件': '更新下载最新的固件失败，使用本地默认固件',
      '左侧高球': '左侧高球',
      '右侧高球': '右侧高球',
      '左侧低球': '左侧低球',
      '右侧高球': '右侧低球',
      '查看详细日志': '查看详细日志',
      '手动模式': '手动模式',
      '结束手动模式': '结束手动模式',
      '位置校准': '位置校准',
      '请求系统状态': '请求系统状态',
      '网球发球机器人':'网球发球机器人',
      '更多功能':'更多功能',
      '设置':'设置',
      '调节':'调节'
      // 添加所有需要翻译的文本
    },
    'en': {
      '烧录': 'Burn',
      'OTA升级': 'OTA Upgrade',
      '设备': 'Device',
      '更多': 'More',
      '重新搜索': 'Re-search',
      '版本号': 'Version Number',
      'Build号': 'Build Number',
      '功能配置': 'Function Configuration',
      '最大移动速度': 'Max Speed',
      '标靶时间间隔': 'Target Time Interval',
      '标靶训练': 'Target Training',
      '力量训练': 'Strength Training',
      '语言切换': 'Language Switch',
      '蓝牙1': 'Make sure Bluetooth is turned on and the device is discoverable',
      '蓝牙2':
          'Make sure location services are turned on (Android 6.0 and above devices require this permission to search for Bluetooth devices)',
      '蓝牙2iOS':
          'Make sure location services are turned on (iOS 13 and above require this permission to use Bluetooth features)',
      '蓝牙3':
          'Make sure the device is within the scanning range and is not connected to by other devices.',
      '设备列表': 'Device List',
      '连接': 'Connect',
      '断开连接': 'Disconnect',
      '移动发球': 'Mobile serve',
      '调节发球': 'Adjust the serve',
      '手动遥控': 'Remote control',
      '正在更新最新固件程序...': 'Updating to the latest firmware...',
      '更新下载最新的固件成功': 'Update and download the latest firmware successfully',
      '更新下载最新的固件失败，使用本地默认固件':
          'Failed to download the latest firmware, using the local default firmware',
      '左侧高球': 'Left high ball',
      '右侧高球': 'Right high ball',
      '左侧低球': 'Left Low Ball',
      '右侧高球': 'Right Low Ball',
      '查看详细日志': 'View detailed logs',
      '手动模式': 'Manual Mode',
      '结束手动模式': 'Exit Manual Mode',
      '位置校准': 'Position calibration',
      '请求系统状态': 'Request system status',
      '网球发球机器人':'Roboti10',
      '更多功能':'More Features',
      '场地类型':'Site Type',

      '设置':'Setting',
      '调节':'Adjust'
// 添加所有需要翻译的文本
    },
  };

  Locale get currentLocale => _currentLocale;

  String getText(String key) {
    return _localizedValues[_currentLocale.languageCode]?[key] ?? key;
  }

  void changeLanguage(Locale locale) {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
  }
}
