// const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
// const kBLE_SERVICE_WRITER_UUID = "ffe5";
// const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
// const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";


import 'package:flutter/cupertino.dart';

const kBLE_SERVICE_NOTIFY_UUID = "fff0";
const kBLE_SERVICE_WRITER_UUID = "fff0";
const kBLE_CHARACTERISTIC_NOTIFY_UUID = "fff1";
const kBLE_CHARACTERISTIC_WRITER_UUID = "fff2";

/*测速器*/
const KBLE_MYSPEEDZ_SERVICE_UUID = 'ffe0';
const KBLE_MYSPEEDZ_CHARACTERISTIC_NOTIFY_UUID = 'ffe4';

const kBLE_270_SERVICE_UUID = "fff0";
const kBLE_270_CHARACTERISTIC_NOTIFY_UUID = "fff1";
const kBLE_270_CHARACTERISTIC_WRITER_UUID = "fff2";

const kBLEDeviceName = "Stickhandling";
const kBLENewDeviceName = "Roboti10";
const kBLEMySpeedzName = "Myspeedz";


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

const kModeControlResponse = 'mode_control_response';

const kStepControlResponse = 'step_control_response';

const kStepControlFinishResponse = 'step_control_finish_response';

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
}



