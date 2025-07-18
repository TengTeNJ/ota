import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'dart:math';

class RightPowerView extends StatefulWidget {
  List<bool> hideIndex;

  RightPowerView({super.key, this.hideIndex = const [false, false, false]});

  @override
  State<RightPowerView> createState() => _RightPowerViewState();
}

class _RightPowerViewState extends State<RightPowerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          (kSanjiaoWidth * kScale + kLiuWidth * kScale + kJuxingSize * kScale)
              .toDouble(),
      height: max(kSanjiaoHeight * kScale, kJuxingSize * kScale) +
          20 +
          kSanjiaoHeight * kScale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.hideIndex[0]
              ? SizedBox(width: kLiuWidth * kScale, height: kLiuHeight * kScale)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/liu.png',
                      width: kLiuWidth * kScale,
                      height: kLiuHeight * kScale,
                    ),
                    SizedBox(
                      width: 26,
                    )
                  ],
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hideIndex[1]
                  ? SizedBox(
                      width: kSanjiaoWidth * kScale,
                      height: kSanjiaoHeight * kScale)
                  : Image.asset(
                      'assets/images/sanjiao.png',
                      width: kSanjiaoWidth * kScale,
                      height: kSanjiaoHeight * kScale,
                    ),
              SizedBox(
                width: (kLiuWidth * kScale).toDouble(),
              ),
              widget.hideIndex[2]
                  ? SizedBox(
                      width: kJuxingSize * kScale, height: kJuxingSize * kScale)
                  : Image.asset(
                      'assets/images/juxing.png',
                      width: kJuxingSize * kScale,
                      height: kJuxingSize * kScale,
                    ),
            ],
          )
        ],
      ),
    );
  }
}
