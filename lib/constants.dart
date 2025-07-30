// const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
// const kBLE_SERVICE_WRITER_UUID = "ffe5";
// const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
// const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota/utils/language_model.dart';
import 'package:provider/provider.dart';

const kBLE_SERVICE_NOTIFY_UUID = "fff0";
const kBLE_SERVICE_WRITER_UUID = "fff0";
const kBLE_CHARACTERISTIC_NOTIFY_UUID = "fff1";
const kBLE_CHARACTERISTIC_WRITER_UUID = "fff2";

/*摄像头主机*/
const kBLE_CAMERA_SERVICE_NOTIFY_UUID = "ffe0";
const kBLE_CAMERA_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
const kBLE_CAMERA_SERVICE_WRITER_UUID = "ffe5";
const kBLE_CAMERA_CHARACTERISTIC_WRITER_UUID = "ffe9";

/*测速器*/
const KBLE_MYSPEEDZ_SERVICE_UUID = 'ffe0';
const KBLE_MYSPEEDZ_CHARACTERISTIC_NOTIFY_UUID = 'ffe4';

const kBLE_270_SERVICE_UUID = "fff0";
const kBLE_270_CHARACTERISTIC_NOTIFY_UUID = "fff1";
const kBLE_270_CHARACTERISTIC_WRITER_UUID = "fff2";


/// 2 号场设备名字
const kBLEDeviceName = "Tv511u-403F0109";
const kBLENewDeviceName = "Roboti10";
const kBLEMySpeedzName = "Myspeedz_2";

/// 3 号场设备名字

// const kBLEDeviceName = "ARtennis_3";
// const kBLENewDeviceName = "Roboti10";
// const kBLEMySpeedzName = "Myspeedz_3";

const kSanjiaoWidth = 66;
const kSanjiaoHeight = 58;

const kYuanSize =  66;
const kJuxingSize = 58;

const kLiuWidth = 66;
const kLiuHeight = 56;

const kScale = 1.5;

const kHeigthScale = 768.0/375.0;

const kWidhtScale = 1024.0/812.0;




// OTA 进度变化
const kOTAProgress = 'ota_progress_update';

const kOTATextProgress= 'ota_text_progress_update';

const kBLEDisconneted = 'disconnected';
const kBLEConneted = 'connected';

const kBLElog = 'log_show';

const kFindNewDevice = 'find_new_ble_device';

const kHasSendData = 'has_send_data';

const kBLEReady = 'ble_ready';

const kPrePing= 'pre_ping_ff';

const kModeControlResponse = 'mode_control_response'; // 模式控制

// const kModeControlFinishResponse = 'mode_control_finish_response'; // 模式控制完成

const kStepControlResponse = 'step_control_response';

const kStepControlFinishResponse = 'step_control_finish_response'; // 步伐控制结束模式控制结束都会回复这个

const kPowerValue= 'power_value';

const kSpeedValue= 'speed_value';

const kTargetIndex = 'target_index';

class Constants{
  //  屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

//  屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static String keyToString(String key,BuildContext context){
    return Provider.of<LanguageModel>(context, listen: true).getText(key);
  }
  static Text boldWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
        height: height,
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  static Text tengxunBoldWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        bool isHighlight = false }) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
        height: height,
        fontFamily: 'tengxun',
        fontWeight: FontWeight.bold,
        color: isHighlight == true ? Color.fromRGBO(21, 233, 120, 1.0) :  Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  static Text regularWhiteTextWidget(String text, double fontSize,Color color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: color,
          fontSize: fontSize),
    );
  }

  static Text mediumWhiteTextWidget(String text, double fontSize,Color color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: color,
          fontSize: fontSize),
    );
  }
}




