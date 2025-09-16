import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:ota/utils/service_util.dart';
import '../constants.dart';
import 'event_manager.dart';
import 'ota_service_data.dart';
import 'package:get/get.dart';
int crc16Update(List<int> src) {
  int crc = 0;
  for (int byte in src) {
    crc ^= byte << 8;
    for (int i = 0; i < 8; i++) {
      int temp = crc << 1;
      if ((crc & 0x8000) != 0) {
        temp ^= 0x1021;
      }
      crc = temp;
    }
  }
  return crc & 0xFFFF; // 确保结果为 16 位
}

/*
* Ping 握手数据
* */
List<int> pingData() {
  List<int> values = [kBLEDataFrameHeader, 0xa6];
  print('Ping 握手数据');
  return values;
}

List<int> pingPreData() {
  List<int> values = [0xA5];
  print('Ping Pre 握手数据');
  return values;
}

List<int> resetToPreVersion(){
  List<int> values = [0xAA];
  print('强制恢复到上一个版本数据');
  return values;
}

/*
* 通用的ACK回复
* */
List<int> generalACKData() {
  List<int> values = [kBLEDataFrameHeader, 0xa1];
  return values;
}

/*
* 擦除所有的指令
* */
List<int> eraseAllData() {
  List<int> values = [
    kBLEDataFrameHeader,
    0xa4,
    0x08,
    0x00,
    0x0c,
    0x22,
    0x01,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x00
  ];
  print('发送擦除all---');
  return values;
}

/*
* 擦除所有的ACK确认指令
* */
List<int> eraseAllACKData() {
  List<int> values = [kBLEDataFrameHeader, 0xa1];
  return values;
}

void main() {
  bagainWriteData(4);
}

/*
* 开始写的指令 带上数据总长度的参数
* */
List<int> bagainWriteData(int length) {
  print('length = ${length}');
  final byteData = ByteData(4);
  byteData.setUint32(0, length, Endian.little); // 小端格式写入
  List<int> lengthDatas = [
    byteData.getUint8(0),
    byteData.getUint8(1),
    byteData.getUint8(2),
    byteData.getUint8(3),
  ];

  List<int> _tempValue = [
    0x5a,
    0xa4,
    0x0c,
    0x00,
    0x04,
    0x00,
    0x00,
    0x02,
    0x00,
    0x80,
    0x00,
    0x08,
    lengthDatas[0],
    lengthDatas[1],
    lengthDatas[2],
    lengthDatas[3]
  ];
  int _value = crc16Update(_tempValue);
  List<int> finalValue = [
    _value & 0xFF, // 低位字节
    (_value >> 8) & 0xFF // 高位字节
  ];
  _tempValue.insert(4, finalValue.first);
  _tempValue.insert(5, finalValue.last);
  print('开始写的指令');
  return _tempValue;
}

/*
* 发送真实的数据过去
* */
List<int> realBuildWirterCommand(List<int> data) {
  int _dataLength = data.length;
  final byteData = ByteData(2);
  byteData.setUint16(0, data.length, Endian.little); // 小端格式写入
  List<int> lengthDatas = [
    byteData.getUint8(0),
    byteData.getUint8(1),
  ];

  // 集合除了crc的所有值
  List<int> _tempValue = [0x5a, 0xa5, lengthDatas[0], lengthDatas[1]];
  _tempValue.addAll(data);

  int _value = crc16Update(_tempValue);
  List<int> finalValue = [
    _value & 0xFF, // 低位字节
    (_value >> 8) & 0xFF // 高位字节
  ];
  _tempValue.insert(4, finalValue.first);
  _tempValue.insert(5, finalValue.last);
  print(
      "realBuildWirterCommand --- data = ${_tempValue.map((toElement) => toElement.toRadixString(16)).toList()}");

  CommStatusManager().hasSendDataLength += data.length;
  EventBusManager().eventBus.fire(DataUpdatedEvent(kHasSendData));

  return _tempValue;
}

List<int> resetData() {
  print('reset');
  return [0x5a, 0xa4, 0x04, 0x00, 0x6f, 0x46, 0x0b, 0x00, 0x00, 0x00];
}

List<int>systemResetData(){
  print('系统复位');
  List<int> data = [kBLEDataFrameHeader,6,0x05,0x01,0xff,0xaa];
  return data;
}

List<int>changeModeData(int mode){
  print('切换模式--${mode}');
  List<int> data = [kBLEDataFrameHeader,6,0x06,mode,0xff,0xaa];
  return data;
}

List<int> setSpeedData(double x,double y){
  // 保留一位小数并乘以10，但不四舍五入
  //print('x---${x},y---${y}');
  int xSpeed = (x * 10).truncate();
  int ySpeed = (y * 10).truncate();
  //print('设置速度--${xSpeed}---${ySpeed}');
  List<int> data = [kBLEDataFrameHeader,8,0x03,xSpeed,ySpeed,0,0xff,0xaa];
 // print('data=${data}');
  print(
      "设置速度  = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");

  return data;
}

/*
* 步伐控制
* */
List<int> stepControlData(TennisMachineParams params){
  List<int> data = [kBLEDataFrameHeader,19,0x04];
 // x轴
  data.addAll( intToBytes(params.xPosition));
  // y轴
  data.addAll( intToBytes(params.yPosition));
  // z轴
  data.addAll( intToBytes(params.zRotation));
  // 上发球轮
  data.add(params.topWheelSpeed);
  // 下发球轮
  data.add(params.bottomWheelSpeed);
  // 转盘
  data.add(params.turntableSpeed);
  // 发球角度
  data.addAll( intToBytes(params.ballAngle));
  // 发球间隔
  data.addAll( intToBytes((params.ballInterval).round()));
  // 发球球数
  data.add(params.ballCount);

  data.addAll([0xff,0xaa]);
  print("步伐控制data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
  CommStatusManager().isStepControlling = true;
  final stackTrace = StackTrace.current.toString().split("\n");


  CommStatusManager().logDatas.add(
      'APP 发送步伐控制${stackTrace[1]} ${data.map((toElement) => toElement.toRadixString(16)).toList()}');

  EventBusManager().eventBus.fire(DataUpdatedEvent(kBLElog));
  if(CommStatusManager().stepTimeOutTimer == null){
    CommStatusManager().stepTimeOutTimer = Timer(const Duration(milliseconds: 500), () {
      print('500毫秒后执行一次，超时重发');
      CommStatusManager().stepTimeOutCount ++;
      if(CommStatusManager().stepTimeOutCount >= 10){
        CommStatusManager().stepTimeOutCount = 0;
        Get.snackbar("提示", "蓝牙通讯异常，请重启机器人设备重试"); // 不需要 context
        return;
      }
      CommStatusManager().writerData(stepControlData(params));
    }); // 一次性延迟执行
  }
  return data;
}

List<int>systemFeedbackData(){
  print('请求系统状态反馈指令');
  List<int> data = [kBLEDataFrameHeader,6,0x09,0x01,0xff,0xaa];
  return data;
}

List<int>positionCheckData(){
  print('位置校准');
  List<int> data = [kBLEDataFrameHeader,6,0x08,0x01,0xff,0xaa];
  return data;
}
