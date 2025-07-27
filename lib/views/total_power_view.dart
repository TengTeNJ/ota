import 'package:flutter/material.dart';
import 'package:ota/views/left_power_view.dart';
import 'package:ota/views/middle_power_view.dart';
import 'package:ota/views/right_power_view.dart';
import 'dart:math';

import '../constants.dart';

class TotalPowerView extends StatefulWidget {
  List<bool> hideIndex;

  TotalPowerView(
      {super.key,
      this.hideIndex = const [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ]});

  @override
  State<TotalPowerView> createState() => _TotalPowerViewState();
}

class _TotalPowerViewState extends State<TotalPowerView> {
  @override
  Widget build(BuildContext context) {
    List<bool> _leftDatas = [false, false, false];
    List<bool> _middleDatas = [false, false, false];
    List<bool> _rightDatas = [false, false, false];

    double _leftHeight = max(kSanjiaoHeight * kScale, kLiuHeight * kScale) +  20 +  kYuanSize * kScale;
    double _middleHeight = max(kJuxingSize * kScale, kYuanSize * kScale) + 20 + kSanjiaoHeight * kScale;
    double _rightHeight = max(kSanjiaoHeight * kScale, kJuxingSize * kScale) + 20 + kSanjiaoHeight * kScale;


    if (widget.hideIndex.length >= 9) {
      _leftDatas.clear();
      _leftDatas.addAll(widget.hideIndex.sublist(0, 3));

      _middleDatas.clear();
      _middleDatas.addAll(widget.hideIndex.sublist(3, 6));

      _rightDatas.clear();
      _rightDatas.addAll(widget.hideIndex.sublist(6, 9));
    }
    return Container(
      // margin: EdgeInsets.only(left: 32,right: 32),
      height: max(max(_leftHeight, _rightHeight), _middleHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.red,
            margin: EdgeInsets.only(left: 100),
            child:LeftPowerView(
              hideIndex: _leftDatas,
            ),
          ),

          Container(
            // color: Colors.red,
            child:MiddlePowerView(
              hideIndex: _middleDatas,
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 100),
            // color: Colors.red,
            child:  RightPowerView(
              hideIndex: _rightDatas,
            ),
          ),

        ],
      ),
    );
  }
}
