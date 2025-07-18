import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'dart:math';

class LeftPowerView extends StatefulWidget {
  List<bool> hideIndex ;
   LeftPowerView({super.key,this.hideIndex = const [false,false,false]});

  @override
  State<LeftPowerView> createState() => _LeftPowerViewState();
}

class _LeftPowerViewState extends State<LeftPowerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kYuanSize*kScale + kSanjiaoWidth *kScale + kLiuWidth*kScale,
      height: max(kSanjiaoHeight * kScale, kLiuHeight * kScale) +
          20 +
          kYuanSize * kScale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hideIndex[0] ? Container(width: kYuanSize*kScale,height: kYuanSize*kScale) : Image.asset('assets/images/yuan.png',width: kYuanSize*kScale,height: kYuanSize*kScale,),
              SizedBox(width: 32,)
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hideIndex[1] ? Container(width: kSanjiaoWidth*kScale,height: kSanjiaoHeight*kScale) : Image.asset('assets/images/sanjiao.png',width: kSanjiaoWidth*kScale,height: kSanjiaoHeight*kScale,),
              SizedBox(width: kYuanSize*kScale,),
              widget.hideIndex[2] ? Container(width: kLiuWidth*kScale,height: kLiuHeight*kScale) : Image.asset('assets/images/liu.png',width: kLiuWidth*kScale,height: kLiuHeight*kScale,),
            ],
          )
        ],
      ),
    );
  }
}
