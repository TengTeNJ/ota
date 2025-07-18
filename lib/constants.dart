// const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
// const kBLE_SERVICE_WRITER_UUID = "ffe5";
// const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
// const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";


import 'package:flutter/cupertino.dart';
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

const kBLEDeviceName = "Stickhandling";
const kBLENewDeviceName = "Roboti10";
const kBLEMySpeedzName = "Myspeedz";

const kSanjiaoWidth = 66;
const kSanjiaoHeight = 58;

const kYuanSize =  66;
const kJuxingSize = 58;

const kLiuWidth = 66;
const kLiuHeight = 56;

const kScale = 1.5;


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
}




