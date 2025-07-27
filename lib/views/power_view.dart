import 'package:flutter/material.dart';

class PowerView extends StatelessWidget {
  const PowerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 40),
      // color: Colors.red,
      width: 206 + 68 *2 + 58,
      height: 132 + 58 * 3 +60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Image.asset('assets/images/sanjiao.png',width: 68*2,height: 58*2,),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/yuan.png',width: 68*2,height: 68*2,),
              SizedBox(width: 80,),
              Image.asset('assets/images/juxing.png',width: 58*2,height: 58*2,),
            ],
          )
        ],
      ),
    );
  }
}
