import 'package:flutter/material.dart';
import 'ntrp_pressure_end_view.dart';
import '../../../constants.dart';

class NtrpPressureEndController extends StatefulWidget {
  int score = 0;
  NtrpPressureEndController({required this.score});

  @override
  State<NtrpPressureEndController> createState() => _NtrpPressureEndControllerState();
}

class _NtrpPressureEndControllerState extends State<NtrpPressureEndController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80, left: 260),
            width: 312 * kWidhtScale + 100,
            height: 202 * kHeigthScale - 50,
            color: Color.fromRGBO(21, 56, 96, 1.0),
            child: NtrpPressureEndView(count: widget.score,)),

          SizedBox(
            height: 20,
          ),

        ],
      ),
    );

  }
}
