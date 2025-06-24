import 'package:flutter/material.dart';
import 'package:ota/constants.dart';

class TargetViews extends StatefulWidget {
  List<bool> showIndes;
  TargetViews({super.key,this.showIndes = const [true,true,true,true,true,true,true,true]});

  @override
  State<TargetViews> createState() => _TargetViewsState();
}

class _TargetViewsState extends State<TargetViews> {
  @override
  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    return Container(
      width: Constants.screenWidth(context) - 98,
      height: _width * 2,
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: _width,
                height: _width,
              ),
              Visibility(
                  visible: widget.showIndes[0],
                  child:  Image.asset('assets/images/sanjiao.png',width: _width,height: _width,))
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              SizedBox(
                width: _width,
                height: _width,
              ),
              Visibility(
                  visible: widget.showIndes[1],
                  child:  Image.asset('assets/images/liu.png',width: _width,height: _width,))
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              Visibility(
                  visible: widget.showIndes[2],
                  child:  Image.asset('assets/images/yuan.png',width: _width,height: _width,)),
              SizedBox(
                width: _width,
                height: _width,
              ),
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              SizedBox(
                width: _width,
                height: _width,
              ),
              Visibility(
                  visible: widget.showIndes[3],
                  child:  Image.asset('assets/images/juxing.png',width: _width,height: _width,))
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              Visibility(
                  visible: widget.showIndes[4],
                  child:  Image.asset('assets/images/sanjiao.png',width: _width,height: _width,)),
              SizedBox(
                width: _width,
                height: _width,
              ),
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              SizedBox(
                width: _width,
                height: _width,
              ),
              Visibility(
                  visible: widget.showIndes[5],
                  child:  Image.asset('assets/images/yuan.png',width: _width,height: _width,))
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              Visibility(
                  visible: widget.showIndes[6],
                  child:  Image.asset('assets/images/liu.png',width: _width,height: _width,)),
              SizedBox(
                width: _width,
                height: _width,
              ),
            ],
          ),
          SizedBox(width: 28,),
          Column(
            children: [
              SizedBox(
                width: _width,
                height: _width,
              ),
              Visibility(
                  visible: widget.showIndes[7],
                  child:  Image.asset('assets/images/juxing.png',width: _width,height: _width,))
            ],
          ),
        ],
      ),
    );
  }
}
