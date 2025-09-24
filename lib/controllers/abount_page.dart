import 'package:any_loading/any_loading.dart';
import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/count_down_page.dart';
import 'package:ota/controllers/battle/new_battle_target_page.dart';
import 'package:ota/controllers/new_target_single_ppage.dart';
import 'package:ota/controllers/solo/power_page.dart';
import 'package:ota/controllers/gamehome/stadium_two_main_page.dart';
import 'package:ota/controllers/target_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../model/ble_model.dart';
import '../utils/language_model.dart';
import '../utils/ota_data.dart';
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
    final languageModel = Provider.of<LanguageModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(182, 246, 29, 1.0),
          centerTitle: true,
          title: Text(
            '${'${Provider.of<LanguageModel>(context, listen: true).getText('更多功能')}'}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${languageModel.getText(Constants.keyToString('版本号', context))}: ${packageInfo.version}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${languageModel.getText(Constants.keyToString('Build号', context))}:  ${packageInfo.buildNumber}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Text(
              //   '功能配置',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 8),
              // SwitchListTile(
              //   contentPadding:EdgeInsets.zero,
              //   title: Text('暗黑模式'),
              //   value: themeProvider.themeMode == ThemeMode.dark,
              //   onChanged: (value) => themeProvider.toggleTheme(value),
              // ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${languageModel.getText(Constants.keyToString('最大移动速度', context))}: ${CommStatusManager().maxSpeed}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                  Text(
                    '${languageModel.getText(Constants.keyToString('标靶时间间隔', context))}: ${CommStatusManager().targetInteral}秒',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${languageModel.getText(Constants.keyToString('场地类型', context))}: ${CommStatusManager().siteType.toInt()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  NotificationListener<ScrollNotification>(
                    child: NumberPicker(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      value: CommStatusManager().siteType.toInt(),
                      minValue: 1,
                      maxValue: 3,
                      step: 1,
                      onChanged: (value) async {
                        setState(() {
                          CommStatusManager().siteType = value.toDouble();
                          _currentValue = value;
                        });
                      },
                      textMapper: (numberText) {
                        switch (numberText) {
                          case '1':
                            return '草地场';
                          case '2':
                            return '硬底场';
                          case '3':
                            return '少儿场';
                          default:
                            return numberText;
                        }
                      },
                    ),
                    // onNotification: (notification) {
                    //   print('notification=${notification}');
                    //   if (notification is ScrollEndNotification) {
                    //     print("滚动结束，当前值: $_currentValue");
                    //     if (CommStatusManager().currentConnectedDevice != null)
                    //       return true;
                    //     Future.delayed(Duration(seconds: 5), () {
                    //       // 主动连接当前的场地设备
                    //       BLEModel result =
                    //       CommStatusManager().deviceList.firstWhere(
                    //             (element) =>
                    //         element.deviceName!
                    //             .contains(kBLENewDeviceName) &&
                    //             element.deviceName!.contains(
                    //                 CommStatusManager()
                    //                     .siteType
                    //                     .toStringAsFixed(0)),
                    //         orElse: () => BLEModel(), // 没找到返回 -1
                    //       );
                    //       print('+++${result!.hasConected}+++');
                    //       if (result != null &&
                    //           result.device != null &&
                    //           result!.hasConected == false) {
                    //         print('主动连接---');
                    //         CommStatusManager().connectToDevice(result);
                    //       }
                    //     });
                    //   }
                    //   return true;
                    // }
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${languageModel.getText(Constants.keyToString('步伐类型', context))}: ${CommStatusManager().stepType.toInt()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  NumberPicker(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    value: CommStatusManager().stepType.toInt(),
                    minValue: 1,
                    maxValue: 3,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        CommStatusManager().stepType = value.toDouble();
                        _currentValue = value;
                      });
                    },
                  ),
                ],
              ),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  CommStatusManager().isDeviceDeail = true;
                  AnyLoading.showLoading();
                  CommStatusManager().writerData(positionCheckData());
                  Future.delayed(Duration(milliseconds: 1000), () {
                    AnyLoading.dismiss();
                    CommStatusManager().isDeviceDeail = false;
                    if (![4, 5]
                        .contains(CommStatusManager().pcr.index)) {
                      AnyLoading.showError(
                          '位置未校准完毕：${CommStatusManager().pcr.index},请稍后重试！');
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StadiumTwoMainPage()), // 目标页面
                      // MaterialPageRoute(builder: (context) =>NewTargetSinglePpage()), // 目标页面
                      // MaterialPageRoute(builder: (context) =>TargetPage()), // 目标页面
                    );
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${languageModel.getText(Constants.keyToString('标靶训练', context))}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Icon(Icons.track_changes)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SystemUtil.lockScreenHorizontalDirection();
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StadiumTwoMainPage()), // 目标页面
                    );
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${languageModel.getText(Constants.keyToString('力量训练', context))}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Icon(Icons.track_changes)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      languageModel
                          .getText(Constants.keyToString('语言切换', context)),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: DropdownButton<Locale>(
                      value: languageModel.currentLocale,
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          languageModel.changeLanguage(newLocale);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Locale('zh'),
                          child: Text('Chinese'),
                        ),
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('English'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
