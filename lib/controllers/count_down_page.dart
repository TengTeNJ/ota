import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/power_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

//// 倒计时
class CountDownPage extends StatefulWidget {
  const CountDownPage({super.key});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  int _counter = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }
  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PowerPage(type: "p3",)),
          );
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Constants.boldWhiteTextWidget("Ready", 40),
        SizedBox(height: 20,),
        new CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 4.0,
          percent: 1.0,
          center:
          Text(
            '${_counter}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                fontFamily: 'tengxun',
                color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
          progressColor: Color.fromRGBO(21, 233, 120, 1.0),
        ),
      ],
    )

    // Text(
    //   '$_counter',
    //   style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    // ),
    ),
    );
  }
}
