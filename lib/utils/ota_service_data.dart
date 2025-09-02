import 'package:ota/constants.dart';

import 'comm_statu_manager.dart';
import 'dart:async';
import 'event_manager.dart';
import 'ota_data.dart';

final List<CommProgress> progressDatas = [
  CommProgress.idle,
  CommProgress.ping,
  CommProgress.eraseAll,
  CommProgress.begainWrite,
  CommProgress.sendingData,
  CommProgress.reset,
  CommProgress.finished,
];
final List<CommProgress> factoryProgressDatas = [
  CommProgress.ping,
  CommProgress.eraseAll,
  CommProgress.begainWrite,
  CommProgress.sendingData,
  CommProgress.reset,
  CommProgress.finished,
];

Timer? prePingTimer;
const kBLEDataFrameHeader = 0x5A; // 蓝牙数据帧头
const kACKPacketType = 0xA4; // ACK PacketType
const kLapCommandId = 0x07; // Iap升级反馈,不升级时升级状态为0  同时有版本号 0是完成
const List<int> _systemResetResponse = [0x5a, 0x06, 0x15, 0x01, 0xff, 0xaa];
const List<int> _pingResponse = [
  0x5a,
  0xa7,
  0x00,
  0x02,
  0x01,
  0x50,
  0x00,
  0x00,
  0xaa,
  0xea
];
const List<int> _eraseAllResponse1 = [0x5a, 0xa1];
const List<int> _eraseAllResponse2 = [
  0x5a,
  0xa4,
  0x0c,
  0x00,
  0x66,
  0xce,
  0xa0,
  0x00,
  0x00,
  0x02,
  0x00,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00
];
const List<int> _begainWriteResponse1 = [0x5a, 0xa1];
const List<int> _begainWriteResponse2 = [
  0x5a,
  0xa4,
  0x0c,
  0x00,
  0xa0,
  0x0e,
  0x04,
  0x01,
  0x00,
  0x02,
  0x00,
  0x04,
  0x00,
  0x20,
  0x40,
  0x00,
  0x00,
  0x00
];
const List<int> _ackResponse = [0x5a, 0xa1];
const List<int> _realWriteResponse = [
  0x5a,
  0xa4,
  0x0c,
  0x00,
  0x23,
  0x72,
  0xa0,
  0x00,
  0x00,
  0x02,
  0x00,
  0x00,
  0x00,
  0x00,
  0x04,
  0x00,
  0x00,
  0x00
];
const List<int> _resetResponse = [
  0x5a,
  0xa4,
  0x0c,
  0x00,
  0xf8,
  0x0b,
  0xa0,
  0x00,
  0x04,
  0x02,
  0x00,
  0x00,
  0x00,
  0x00,
  0x0b,
  0x00,
  0x00,
  0x00
];
List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;

List<int> bleCameraNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNewCamera = true;
Timer? delayTimer;
Timer? deviceDlayTimer;

bool areListsEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _dataIndex = 0;

sendPrePing() {
  if (prePingTimer == null) {
    prePingTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      CommStatusManager().writerData(pingPreData());
    });
  } else {
    CommStatusManager().writerData(pingPreData());
  }
}

insertTexts() {
  if (CommStatusManager().isOta) {
    int index = progressDatas.indexOf(CommStatusManager().progress);
    print('index-----${index}');
    switch (index) {
      case 0:
        if (CommStatusManager().otaStrings[0].length != 0) {
          CommStatusManager().otaStrings[0] =
              '${CommStatusManager().otaStrings[0]} \n1.1 收到重置回复';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 1:
        if (CommStatusManager().otaStrings[1].length == 0) {
          CommStatusManager().otaStrings[1] = '2.1 收到Ping回复';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 2:
        if (CommStatusManager().otaStrings[2].length == 0) {
          CommStatusManager().otaStrings[2] = '3.1 收到EraseAll回复1';
        } else {
          CommStatusManager().otaStrings[2] =
              '${CommStatusManager().otaStrings[2]}\n3.2 收到EraseAll回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 3:
        if (CommStatusManager().otaStrings[3].length == 0) {
          CommStatusManager().otaStrings[3] = '4.1收到开始写回复1';
        } else {
          CommStatusManager().otaStrings[3] =
              '${CommStatusManager().otaStrings[3]}\n4.2 收到开始写回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 4:
        if (CommStatusManager().otaStrings[4].length == 0) {
          CommStatusManager().otaStrings[4] = '5.1 发送第一包数据';
        } else {
          CommStatusManager().otaStrings[4] =
              '${CommStatusManager().otaStrings[4]}\n5.2 发送完毕';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 5:
        if (CommStatusManager().otaStrings[5].length == 0) {
          CommStatusManager().otaStrings[5] = '6.1 收到reset回复';
        } else {
          CommStatusManager().otaStrings[5] =
              '${CommStatusManager().otaStrings[5]}\n6.2收到reset回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 6:
        CommStatusManager().otaStrings[6] = '7.1 升级完成';
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
    }
  } else {
    int index = factoryProgressDatas.indexOf(CommStatusManager().progress);
    print('index-----${index}');
    switch (index) {
      case 0:
        if (CommStatusManager().factoryStrings[0].length == 0) {
          CommStatusManager().factoryStrings[0] = '1.2 收到Ping回复';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 1:
        if (CommStatusManager().factoryStrings[1].length == 0) {
          CommStatusManager().factoryStrings[1] = '2.1 收到EraseAll回复1';
        } else {
          CommStatusManager().factoryStrings[1] =
              '${CommStatusManager().factoryStrings[2]}\n2.2 收到EraseAll回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 2:
        if (CommStatusManager().factoryStrings[2].length == 0) {
          CommStatusManager().factoryStrings[2] = '3.1收到开始写回复1';
        } else {
          CommStatusManager().factoryStrings[2] =
              '${CommStatusManager().factoryStrings[3]}\n3.2 收到开始写回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 3:
        if (CommStatusManager().factoryStrings[3].length == 0) {
          CommStatusManager().factoryStrings[3] = '4.1 发送第一包数据';
        } else {
          CommStatusManager().factoryStrings[3] =
              '${CommStatusManager().factoryStrings[4]}\n4.2 发送完毕';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 4:
        if (CommStatusManager().factoryStrings[4].length == 0) {
          CommStatusManager().factoryStrings[4] = '5.1 收到reset回复';
        } else {
          CommStatusManager().factoryStrings[4] =
              '${CommStatusManager().factoryStrings[4]}\n5.2收到reset回复2';
        }
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
        break;
      case 5:
        CommStatusManager().factoryStrings[5] = '.1 升级完成';
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTATextProgress));
    }
  }
}

handleTimeOut(String msg) {
  if (CommStatusManager().timer == null) {
    CommStatusManager().timer = Timer(Duration(milliseconds: 60000), () {
      bleNotAllData.clear();
      print('${msg}接收超时');
      CommStatusManager().timer?.cancel();
    });
  } else {
    CommStatusManager().timer?.cancel();
    CommStatusManager().timer = Timer(Duration(milliseconds: 60000), () {
      bleNotAllData.clear();
      print('${msg}接收超时');
      CommStatusManager().timer?.cancel();
    });
  }
}

List<int> parseTargetsHit(List<int> bytes) {
  if (bytes.length != 2) {
    throw ArgumentError('必须是两个字节');
  }

  int value = (bytes[0] << 8) | bytes[1];

  List<int> hitTargets = [];
  for (int i = 0; i < 16; i++) {
    if ((value & (1 << i)) != 0) {
      hitTargets.add(i); // 第 i 个标靶被击中
    }
  }

  return hitTargets;
}

// Timer _timer;
class OTAServiceDataParse {
  /*解析摄像头的数据*/
  static handleData(List<int> element) {
    print('----element==$element}');

    /// 虚拟标靶击中的索引
    if (element[2] == 0x10) {
      List<int> targets = [
        element[3],
        element[4],
      ];
      List<int> temp = parseTargetsHit(targets);
      CommStatusManager().targetIndex = temp;
      EventBusManager().eventBus.fire(DataUpdatedEvent(kTargetIndex));

      print('targets=${temp}');
    }
  }

  static handleNotFullData(List<int> data) {
    bleCameraNotAllData.addAll(data);
    if (isNewCamera) {
      isNewCamera = false;
      delayTimer = Timer(Duration(milliseconds: 150), () {
        if (!isNewCamera) {
          print(
              '解析数据超时 ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
          delayTimer?.cancel();
          bleCameraNotAllData.clear();
          isNewCamera = true;
        }
      });
    } else {
      // print('handleNotFullData3${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
      if (bleCameraNotAllData.length >= 4 &&
          bleCameraNotAllData[0] == kBLEDataFrameHeader) {
        int length = bleCameraNotAllData[1];
        if (bleCameraNotAllData.length >= length &&
            bleCameraNotAllData[length - 1] == 0XAA) {
          List<int> rightData = bleCameraNotAllData.sublist(0, length);
          handleData(rightData); // 完整的一帧数据
          List<int> othersData =
              bleCameraNotAllData.sublist(length, bleNotAllData.length);
          isNewCamera = true;
          bleCameraNotAllData.clear();
          if (delayTimer != null) {
            delayTimer!.cancel();
          }
          if (!othersData.isEmpty) {
            parseCameraData(othersData);
          }
        }
      }
    }
  }

  static parseCameraData(List<int> data) {
    if (data.isEmpty) {
      return;
    }
    if (data.length >= 4 && data[0] == 0xA5) {
      // 取出来数据的长度标识位
      int length = data[1];
      // 通过 帧头 帧尾 length数据位的值和实际的数据包length进行匹配
      if (data.length >= length && data[length - 1] == 0XAA) {
        List<int> rightData = data.sublist(0, length);
        handleData(rightData); // 完整的一帧数据
        List<int> othersData = data.sublist(length, data.length);
        isNewCamera = true;
        bleCameraNotAllData.clear();
        if (delayTimer != null) {
          delayTimer!.cancel();
        }
        if (!othersData.isEmpty) {
          print('othersData=${othersData}');
          parseCameraData(othersData);
        }
      } else {
        handleNotFullData(data);
      }
    } else {
      handleNotFullData(data);
    }
  }

/*-------------------------------------------------⬆️摄像头--------发球机⬇️----------------------------------------------------------------------------*/
  /*解析发球机的数据*/
  static handleDeviceData(List<int> element) {
    print('----handleDeviceData==$element}');
    bleNotAllData.addAll(element);
    if (element.length == element[1] && element.length >= 3) {
      int cmd = element[2];
      int value = element[3];
      print('cmd=${cmd}');
      if (cmd == 0x16) {
        print('控制模式的回复:${value}');
        if (value == 1) {
          // 收到模式控制的回复
          EventBusManager()
              .eventBus
              .fire(DataUpdatedEvent(kModeControlResponse));
        } else {
          // 收到模式控制完成的回复
          EventBusManager()
              .eventBus
              .fire(DataUpdatedEvent(kModeControlResponse));
        }
      } else if (cmd == 0x14) {
        print('步伐控制步伐的回复${bleNotAllData[3]}');
        if (bleNotAllData.length >= 3 && bleNotAllData[2] == 0x14) {
          if (bleNotAllData[3] == 2) {
            CommStatusManager().isStepControlling = false;
            EventBusManager()
                .eventBus
                .fire(DataUpdatedEvent(kStepControlFinishResponse));
          } else if (bleNotAllData[3] == 1) {
            // 收到1之后 清除超时定时器
            print('收到1清空定时器');
            // 清空超时次数
            CommStatusManager().stepTimeOutCount = 0;
            // 清空超时定时器
            CommStatusManager().stepTimeOutTimer?.cancel();
          }
        }
      } else if (cmd == 0x19) {
        print('系统状态反馈');
        // 0：初始化，1：运行，2：停止，3：校零
        int statu = bleNotAllData[3];
        int batteryValue = bleNotAllData[4];
        int error1 = bleNotAllData[5];
        int error2 = bleNotAllData[6];
        print('系统状态:${statu}');
        print('电池电量:${batteryValue}');
        CommStatusManager().powerValue = batteryValue;
        print('故障信息1:${error1}');
        print('故障信息2:${error2}');
        String version =
            '${bleNotAllData[7]}.${bleNotAllData[8]}.${bleNotAllData[9]}.${bleNotAllData[10]}';
        print('版本号:${version}');
        CommStatusManager().versionName = version;
        // 角度值
        int hightAngle = bleNotAllData[11];
        int lowAngle = bleNotAllData[12];
        print('hightAngle=${hightAngle}lowAngle=${lowAngle}');
        String _angelValue = (((hightAngle << 8) | lowAngle)/10.0).toStringAsFixed(1);
        CommStatusManager().angleValue = _angelValue;

        EventBusManager().eventBus.fire(DataUpdatedEvent(kPowerValue));
      } else if (cmd == 0x18) {
        print('位置校准的回复${bleNotAllData[3]}');
      }
      bleNotAllData.clear();
    }
  }

  static parseData(List<int> data) {
    if (data.isEmpty) {
      return;
    }
    print('data=${data}');
    // if (bleNotAllData.length > 20) {
    //   bleNotAllData.clear();
    // }
    print('bleNotAllData=${bleNotAllData}');
    print(
        'CommStatusManager().isDeviceDeail=${CommStatusManager().isDeviceDeail}');
    if (CommStatusManager().isDeviceDeail) {
      // 发球机设备控制相关的
      // bleNotAllData.addAll(data);
      if (data.length >= 4 && data[0] == kBLEDataFrameHeader) {
        // 取出来数据的长度标识位
        int length = data[1];
        // 通过 帧头 帧尾 length数据位的值和实际的数据包length进行匹配
        print('data=${data}');
        if (data.length >= length && data[length - 1] == 0XAA) {
          List<int> rightData = data.sublist(0, length);
          handleDeviceData(rightData); // 完整的一帧数据
          List<int> othersData = data.sublist(length, data.length);
          isNewCamera = true;
          bleNotAllData.clear();
          if (deviceDlayTimer != null) {
            deviceDlayTimer!.cancel();
          }
          if (!othersData.isEmpty) {
            print('othersData=${othersData}');
            parseData(othersData);
          }
        } else {
          handleDeviceNotFullData(data);
        }
      } else {
        handleDeviceNotFullData(data);
      }
      // if (bleNotAllData[0] == 0x5a && bleNotAllData.length >= 4) {
      //   handleDeviceNotFullData(data);
      //   // if (bleNotAllData.length == bleNotAllData[1] &&
      //   //     bleNotAllData.length >= 3) {
      //   //   int cmd = bleNotAllData[2];
      //   //   int value = bleNotAllData[3];
      //   //   print('cmd=${cmd}');
      //   //   if (cmd == 0x16) {
      //   //     print('控制模式的回复:${value}');
      //   //     if (value == 1) {
      //   //       // 收到模式控制的回复
      //   //       EventBusManager()
      //   //           .eventBus
      //   //           .fire(DataUpdatedEvent(kModeControlResponse));
      //   //     } else {
      //   //       // 收到模式控制完成的回复
      //   //       EventBusManager()
      //   //           .eventBus
      //   //           .fire(DataUpdatedEvent(kModeControlResponse));
      //   //     }
      //   //   } else if (cmd == 0x14) {
      //   //     print('步伐控制步伐的回复${bleNotAllData[3]}');
      //   //     if (bleNotAllData.length >= 3 &&
      //   //         bleNotAllData[3] == 2 &&
      //   //         bleNotAllData[2] == 0x14) {
      //   //       CommStatusManager().isStepControlling = false;
      //   //       EventBusManager()
      //   //           .eventBus
      //   //           .fire(DataUpdatedEvent(kStepControlFinishResponse));
      //   //     }
      //   //   } else if (cmd == 0x19) {
      //   //     print('系统状态反馈');
      //   //     // 0：初始化，1：运行，2：停止，3：校零
      //   //     int statu = bleNotAllData[3];
      //   //     int batteryValue = bleNotAllData[4];
      //   //     int error1 = bleNotAllData[5];
      //   //     int error2 = bleNotAllData[6];
      //   //     print('系统状态:${statu}');
      //   //     print('电池电量:${batteryValue}');
      //   //     CommStatusManager().powerValue = batteryValue;
      //   //     print('故障信息1:${error1}');
      //   //     print('故障信息2:${error2}');
      //   //     String version =
      //   //         '${bleNotAllData[7]}.${bleNotAllData[8]}.${bleNotAllData[9]}.${bleNotAllData[10]}';
      //   //     print('版本号:${version}');
      //   //     CommStatusManager().versionName = version;
      //   //
      //   //     EventBusManager().eventBus.fire(DataUpdatedEvent(kPowerValue));
      //   //   } else if (cmd == 0x18) {
      //   //     print('位置校准的回复${bleNotAllData[3]}');
      //   //   }
      //   //   bleNotAllData.clear();
      //   // }
      // }
      return;
    }
    if (CommStatusManager().progress == CommProgress.ready) {
      return;
/*
* Byte0	Byte1	Byte2	Byte3	..........	Byte3+n	Byte4+n	Byte5+n	Byte6+n	Byte7+n
0x5a	Len					id_h	id_l	Sum	0xaa
* */
      bleNotAllData.addAll(data);
      if (data.isNotEmpty &&
          data.length >= 5 &&
          bleNotAllData[1] == bleNotAllData.length) {
        int length = bleNotAllData[1]; // 总长度
        int commandId = bleNotAllData[2]; // 指令id
        if (commandId == kLapCommandId) {
          if (bleNotAllData.length >= 10) {
            int statu = bleNotAllData[3]; // 0：正常；1：校验失败；2：无可用固件；3:备份空间不足
            print('升级状态:${statu}');
            int version1 = bleNotAllData[4];
            int version2 = bleNotAllData[5];
            int version3 = bleNotAllData[6];
            int version4 = bleNotAllData[7];
            String _version = '${version4}.${version3}.${version2}.${version1}';
            print('版本号:${_version}');
            CommStatusManager().versionName = _version;
            // 刷新进度
            EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));
            bleNotAllData.clear();
          }
        }
      }
    } else if (CommStatusManager().progress == CommProgress.idle) {
      print('++++++------');
      handleTimeOut('系统复位');
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _systemResetResponse)) {
        // 代表收到正确的回复 可以进入到下一个环节：清除all
        print('收到系统复位回复');
        /**111*/
        insertTexts();
        bleNotAllData.clear();
        CommStatusManager().timer?.cancel();

        CommStatusManager().progress = CommProgress.ping;

        sendPrePing();

        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));
      }
    } else if (CommStatusManager().progress == CommProgress.ping) {
      /* 发送的是Ping Packet 0x5a 0xa6
       回复的是0x5a 0xa7 0x00 0x02 0x01 0x50 0x00 0x00 0xaa 0xea
    * */
      print('++++++');
      handleTimeOut('Ping');
      bleNotAllData.addAll(data);
      print('--${bleNotAllData.length}---');
      if (areListsEqual(bleNotAllData, _pingResponse)) {
        // 代表收到正确的回复 可以进入到下一个环节：清除all
        print('收到ping回复');
        /**111*/
        insertTexts();

        bleNotAllData.clear();
        CommStatusManager().progress = CommProgress.eraseAll;

        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));

        CommStatusManager().timer?.cancel();
        CommStatusManager().writerData(eraseAllData());
      } else if (areListsEqual(bleNotAllData, [0xFF])) {
        bleNotAllData.clear();
        prePingTimer?.cancel();
        prePingTimer = null;
        CommStatusManager().writerData(pingData());
      }
    } else if (CommStatusManager().progress == CommProgress.eraseAll) {
      // 发送的是0x5a a4 08 00 0c 22 01 00 00 01 00 00 00 00
      /*回复的有：
      ACK: 0x5a a1
      Generic Response :0x5a a4 0c 00 66 ce a0 00 00 02 00 00 00 00 01 00 00 00
      */
      // late Timer _timer;
      // _timer = Timer(Duration(milliseconds: 30000), () {
      //   bleNotAllData.clear();
      //   print('EraseAll接收超时');
      //   // 进行重发处理
      // });
      handleTimeOut('EraseAl');

      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _eraseAllResponse1)) {
        print('收到eraseAll的ACK回复1');
        /**111*/
        insertTexts();
        // 收到ACK回复
        bleNotAllData.clear();
        CommStatusManager()
            .timer
            ?.cancel(); // CommStatusManager().writerData(eraseAllACKData());
      }
      if (areListsEqual(bleNotAllData, _eraseAllResponse2)) {
        print('收到eraseAll的回复2');
        /**111*/
        insertTexts();
        CommStatusManager().timer?.cancel(); // 收到Generic Response
        bleNotAllData.clear();
        // TODO: 此时需要app给设备再发送一个ACK包  0x5a a1
        CommStatusManager().writerData(eraseAllACKData());
        // 发送完就入到下一步 发送写指令
        CommStatusManager().progress = CommProgress.begainWrite;
        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));
        Future.delayed(Duration(milliseconds: 100), () {
          // 发送写指令
          CommStatusManager()
              .writerData(bagainWriteData(CommStatusManager().binData.length));
        });
      }
    } else if (CommStatusManager().progress == CommProgress.begainWrite) {
      handleTimeOut('开始写');

      // 发送的是WriteMemory: startAddress = 0x20000400, byteCount = 0x64
      // 0x5a a4 0c 00 06 5a 04 00 00 02 00 04 00 20 64 00 00 00
      /*回复的有：
      ACK: 0x5a a1
      Generic Response :0x5a a4 0c 00 a0 0e 04 01 00 02 00 04 00 20 40 00 00 00
      */
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _begainWriteResponse1)) {
        // 收到ACK回复
        print('收到开始写的ACK的回复1');
        /**111*/
        insertTexts();

        bleNotAllData.clear();
      }
      // 暂且只校验前四位
      if (bleNotAllData.length >= 6) {
        if (areListsEqual(bleNotAllData.sublist(0, 4),
                _begainWriteResponse2.sublist(0, 4)) ||
            areListsEqual(bleNotAllData.sublist(2, 6),
                _begainWriteResponse2.sublist(0, 4))) {
          // 收到Generic Response
          print('收到开始写的的回复2');
          /**111*/
          insertTexts();

          bleNotAllData.clear();

          CommStatusManager().timer?.cancel();
          // 收到Generic Response
          // TODO: 此时需要app给设备再发送一个ACK包  0x5a a1
          // 发送完就入到下一步 发送写指令
          CommStatusManager().progress = CommProgress.sendingData;

          EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));

          CommStatusManager().writerData(eraseAllACKData());
          Future.delayed(Duration(milliseconds: 500), () {
            // 开始发送第一包数据
            print('开始真正发送第一包数据');
            CommStatusManager().writerData(realBuildWirterCommand(
                CommStatusManager().packetBinDatas[_dataIndex]));
            insertTexts();
          });
        }
      }
    } else if (CommStatusManager().progress == CommProgress.sendingData) {
      // 每发一包数据 都会受到一次ACK确认0x5a a1
      handleTimeOut('发送数据');
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _ackResponse)) {
        CommStatusManager().timer?.cancel();
        bleNotAllData.clear();
        _dataIndex++;
        if (_dataIndex < CommStatusManager().packetBinDatas.length) {
          CommStatusManager().writerData(realBuildWirterCommand(
              CommStatusManager().packetBinDatas[_dataIndex]));
        } else {}
      } else if (areListsEqual(bleNotAllData, _realWriteResponse) ||
          areListsEqual(bleNotAllData, _ackResponse + _realWriteResponse)) {
        CommStatusManager().timer?.cancel();
        bleNotAllData.clear();
        // 发送ACK 并进入到下一个reset阶段
        print('进入到reset阶段');
        /**111*/
        insertTexts();

        CommStatusManager().writerData(generalACKData());
        CommStatusManager().progress = CommProgress.reset;

        EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));

        Future.delayed(Duration(milliseconds: 100), () {
          CommStatusManager().hasSendDataLength = 0; // 重置
          CommStatusManager().writerData(resetData());
          _dataIndex = 0;
        });
      }
    } else if (CommStatusManager().progress == CommProgress.reset) {
      // late Timer _timer;
      // _timer = Timer(Duration(milliseconds: 1000), () {
      //   bleNotAllData.clear();
      //   print('Ping接收超时');
      //   // 进行重发处理
      // });

      handleTimeOut('Reset-2');
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _ackResponse)) {
        // ACK
        /**111*/
        insertTexts();

        print('收到reset回复1');
        bleNotAllData.clear();
        CommStatusManager().timer?.cancel();
      } else if (bleNotAllData.length >= 6 &&
          (areListsEqual(
                  bleNotAllData.sublist(0, 4), _resetResponse.sublist(0, 4)) ||
              areListsEqual(
                  bleNotAllData.sublist(2, 6), _resetResponse.sublist(0, 4)))) {
        // GenericResponse:
        print('收到reset回复2');
        /**111*/
        insertTexts();

        bleNotAllData.clear();
        CommStatusManager().timer?.cancel();
        Future.delayed(Duration(milliseconds: 100), () {
          // 发送 ACK 确认数据 完成ota升级
          print('ota完成，发送ACK包');
          CommStatusManager().progress = CommProgress.finished;
          /**111*/
          insertTexts();

          EventBusManager().eventBus.fire(DataUpdatedEvent(kOTAProgress));
          CommStatusManager().writerData(generalACKData());
        });
      }
    }
  }

  static handleDeviceNotFullData(List<int> data) {
    bleNotAllData.addAll(data);
    if (isNew) {
      isNew = false;
      deviceDlayTimer = Timer(Duration(milliseconds: 150), () {
        if (!isNew) {
          print(
              '解析数据超时 ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
          // print(Œ
          //     'bleNotAllData.toString()} == ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}}');
          deviceDlayTimer?.cancel();
          bleNotAllData.clear();
          isNew = true;
        }
      });
    } else {
      // print('handleNotFullData3${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
      if (bleNotAllData.length >= 4 &&
          bleNotAllData[0] == kBLEDataFrameHeader) {
        int length = bleNotAllData[1];
        if (bleNotAllData.length >= length &&
            bleNotAllData[length - 1] == 0XAA) {
          List<int> rightData = bleNotAllData.sublist(0, length);
          handleDeviceData(rightData); // 完整的一帧数据
          List<int> othersData =
              bleNotAllData.sublist(length, bleNotAllData.length);
          isNew = true;
          bleNotAllData.clear();
          if (deviceDlayTimer != null) {
            deviceDlayTimer!.cancel();
          }
          if (!othersData.isEmpty) {
            parseData(othersData);
          }
        }
      }
    }
  }
}
