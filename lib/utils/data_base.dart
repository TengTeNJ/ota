import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  /// 设置上发球轮速度
  Future<void> saveTopWheelSpeedData(double ballType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('TopWheelSpeedData', ballType);
  }

  /// 获取上发球轮速度
  Future<double> fetchTopWheelSpeedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('TopWheelSpeedData') ?? 6; //
  }


  /// 设置下发球轮速度
  Future<void> saveBottomWheelSpeedData(double ballType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('BottomWheelSpeedData', ballType);
  }

  /// 获取下发球轮速度
  Future<double> fetchBottomWheelSpeedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('BottomWheelSpeedData') ?? 6; //
  }


  /// 设置发球角度
  Future<void> saveBallAngleData(double ballType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('ballAngleData', ballType);
  }

  /// 获取发球角度
  Future<double> fetchBallAngleData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('ballAngleData') ??130; //
  }




}