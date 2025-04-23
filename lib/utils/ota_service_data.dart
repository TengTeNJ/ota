import 'comm_statu_manager.dart';
import 'dart:async';
import 'ota_data.dart';
const kBLEDataFrameHeader = 0x5A; // 蓝牙数据帧头
const kACKPacketType = 0xA4; // ACK PacketType
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

bool areListsEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _dataIndex = 0;
// Timer _timer;
class OTAServiceDataParse {
  static parseData(List<int> data) {
    if (data.isEmpty) {
      return;
    }
    if (CommStatusManager().progress == CommProgress.ping) {
      /* 发送的是Ping Packet 0x5a 0xa6
       回复的是0x5a 0xa7 0x00 0x02 0x01 0x50 0x00 0x00 0xaa 0xea
    * */
      late Timer _timer;
      _timer = Timer(Duration(milliseconds: 10000), () {
        bleNotAllData.clear();
        print('Ping接收超时');
        _timer.cancel();
      });
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _pingResponse)) {
        // 代表收到正确的回复 可以进入到下一个环节：清除all
        print('收到ping回复');
        bleNotAllData.clear();
        CommStatusManager().progress = CommProgress.eraseAll;
        _timer.cancel();
        CommStatusManager().writerData(eraseAllData());
        _timer.cancel();
      }
    } else if (CommStatusManager().progress == CommProgress.eraseAll) {
      // 发送的是0x5a a4 08 00 0c 22 01 00 00 01 00 00 00 00
      /*回复的有：
      ACK: 0x5a a1
      Generic Response :0x5a a4 0c 00 66 ce a0 00 00 02 00 00 00 00 01 00 00 00
      */
      late Timer _timer;
      _timer = Timer(Duration(milliseconds: 30000), () {
        bleNotAllData.clear();
        print('EraseAll接收超时');
        // 进行重发处理
      });
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _eraseAllResponse1)) {
       print('收到eraseAll的ACK回复1');
        // 收到ACK回复
        bleNotAllData.clear();
       _timer.cancel();
       // CommStatusManager().writerData(eraseAllACKData());
      }
      if (areListsEqual(bleNotAllData, _eraseAllResponse2)) {
        print('收到eraseAll的回复2');
        _timer.cancel();
        // 收到Generic Response
        bleNotAllData.clear();
        // TODO: 此时需要app给设备再发送一个ACK包  0x5a a1
        CommStatusManager().writerData(eraseAllACKData());
        // 发送完就入到下一步 发送写指令
        CommStatusManager().progress = CommProgress.begainWrite;
        Future.delayed(Duration(milliseconds: 100),(){
          // 发送写指令
          CommStatusManager().writerData(bagainWriteData( CommStatusManager().binData.length));
        });
      }
    } else if (CommStatusManager().progress == CommProgress.begainWrite) {
      late Timer _timer;
      _timer = Timer(Duration(milliseconds: 1000), () {
        bleNotAllData.clear();
        // 进行重发处理
      });
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
        bleNotAllData.clear();
      }
      // 暂且只校验前四位
      if(bleNotAllData.length >= 4){
        if (areListsEqual(bleNotAllData.sublist(0,4), _begainWriteResponse2.sublist(0,4))) {
          // 收到Generic Response
          print('收到开始写的的回复2');
          bleNotAllData.clear();
          _timer.cancel();
          // TODO: 此时需要app给设备再发送一个ACK包  0x5a a1
          // 发送完就入到下一步 发送写指令
          CommStatusManager().progress = CommProgress.sendingData;
          CommStatusManager().writerData(eraseAllACKData());
          Future.delayed(Duration(milliseconds: 500),(){
            // 开始发送第一包数据
            print('开始真正发送第一包数据');
            CommStatusManager().writerData(realBuildWirterCommand(CommStatusManager().packetBinDatas[_dataIndex]));
          });
        }
      }
    } else if (CommStatusManager().progress == CommProgress.sendingData) {
      // 每发一包数据 都会受到一次ACK确认0x5a a1
      late Timer _timer;
      _timer = Timer(Duration(milliseconds: 1000), () {
        bleNotAllData.clear();
        print('Ping接收超时');
        // 进行重发处理
      });
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _ackResponse)) {
        _timer.cancel();
        bleNotAllData.clear();
        _dataIndex++;
        if (_dataIndex < CommStatusManager().packetBinDatas.length) {
          CommStatusManager().writerData(realBuildWirterCommand(CommStatusManager().packetBinDatas[_dataIndex]));
        } else {}
      } else if (areListsEqual(bleNotAllData, _realWriteResponse)) {
        _timer.cancel();
        bleNotAllData.clear();
        // 发送ACK 并进入到下一个reset阶段
        print('进入到reset阶段');
        CommStatusManager().writerData(generalACKData());
        CommStatusManager().progress = CommProgress.reset;
        Future.delayed(Duration(milliseconds: 100), () {
          CommStatusManager().writerData(resetData());
        });
      }
    } else if (CommStatusManager().progress == CommProgress.reset) {
      late Timer _timer;
      _timer = Timer(Duration(milliseconds: 1000), () {
        bleNotAllData.clear();
        print('Ping接收超时');
        // 进行重发处理
      });
      bleNotAllData.addAll(data);
      if (areListsEqual(bleNotAllData, _ackResponse)) {
        // ACK
        print('收到reset回复1');
        bleNotAllData.clear();
        _timer.cancel();
      }else if(bleNotAllData.length >= 4 &&  areListsEqual(bleNotAllData.sublist(0,4), _resetResponse.sublist(0,4))){
        // GenericResponse:
        print('收到reset回复2');
        bleNotAllData.clear();
        _timer.cancel();
        Future.delayed(Duration(milliseconds: 100),(){
          // 发送 ACK 确认数据 完成ota升级
          print('ota完成，发送ACK包');
          CommStatusManager().writerData(generalACKData());
        });
      }
    }
  }
}
