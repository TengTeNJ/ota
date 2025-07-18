import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'dart:math';

class MiddlePowerView extends StatefulWidget {
  List<bool> hideIndex;

  MiddlePowerView({super.key, this.hideIndex = const [false, false, false]});

  @override
  State<MiddlePowerView> createState() => _MiddlePowerViewState();
}

class _MiddlePowerViewState extends State<MiddlePowerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kJuxingSize * kScale + kSanjiaoWidth * kScale + kYuanSize * kScale,
      height: max(kJuxingSize * kScale, kYuanSize * kScale) +
          20 +
          kSanjiaoHeight * kScale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.hideIndex[0]
              ? Container(
                  width: kSanjiaoWidth * kScale,
                  height: kSanjiaoHeight * kScale)
              : Image.asset(
                  'assets/images/sanjiao.png',
                  width: kSanjiaoWidth * kScale,
                  height: kSanjiaoHeight * kScale,
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hideIndex[1]
                  ? Container(
                      width: kJuxingSize * kScale, height: kJuxingSize * kScale)
                  : Image.asset(
                      'assets/images/juxing.png',
                      width: kJuxingSize * kScale,
                      height: kJuxingSize * kScale,
                    ),
              SizedBox(
                width: 80,
              ),
              widget.hideIndex[2]
                  ? Container(
                      width: kYuanSize * kScale, height: kYuanSize * kScale)
                  : Image.asset(
                      'assets/images/yuan.png',
                      width: kYuanSize * kScale,
                      height: kYuanSize * kScale,
                    ),
            ],
          )
        ],
      ),
    );
  }
}
