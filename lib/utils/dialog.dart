import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class TTDialog {
  //*游戏暂停弹窗*/
  static gamePauseTaskDialog(BuildContext context, Function exchange) {
    showDialog(
        context: context,
        barrierColor: Color.fromRGBO(18, 83, 157, 1.0),
        builder: (BuildContext context) {
          return Dialog.fullscreen(
            backgroundColor: Color.fromARGB(18, 83, 157, 1),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GamePauseTaskDialog(exchange: exchange),
            ),
          );
        });
  }
}

//*游戏暂停弹窗*/
class GamePauseTaskDialog extends StatelessWidget {
  Function exchange;

  GamePauseTaskDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(18, 83, 157, 1.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 90,
          // ),
          Constants.boldWhiteTextWidget('', 36),

          Container(
            child: Column(
              children: [
                Constants.boldWhiteTextWidget('Pause', 36),
                SizedBox(
                  height: 6,
                ),
                Container(
                  width: 65,
                  height: 27,
                  color: Color.fromRGBO(12, 51, 109, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/arrow.png",
                        width: 8,
                        height: 10,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Constants.boldWhiteTextWidget('Start', 12,
                          fontColor: Color.fromRGBO(21, 233, 120, 1.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            // color: Colors.red,
            margin: EdgeInsets.only(bottom: 40, left: 40, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("退出游戏11");
                    exchange();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 127,
                    height: 55,
                    color: Color.fromRGBO(100, 100, 100, 0.71),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/stop.png',
                          width: 26 / 2,
                          height: 22 / 2,
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Constants.boldWhiteTextWidget("Exit", 20),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      print("退出游戏2");
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 127,
                      height: 55,
                      color: Color.fromRGBO(100, 100, 100, 0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/stop.png',
                            width: 26 / 2,
                            height: 22 / 2,
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Constants.boldWhiteTextWidget("Replay", 20),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
