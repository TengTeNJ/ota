import 'package:flutter/material.dart';

import '../constants.dart';

/// 双人对战结算界面

class NewBattleTargetEndPage extends StatefulWidget {
  int leftTopSpeed;
  int rightTopSpeed;
  int leftAvgSpeed;
  int rightAvgSpeed;



  NewBattleTargetEndPage({required this.leftTopSpeed,
    required this.rightTopSpeed,
    required this.leftAvgSpeed,
    required this.rightAvgSpeed,
  });

  @override
  State<NewBattleTargetEndPage> createState() => _NewBattleTargetEndPageState();
}

class _NewBattleTargetEndPageState extends State<NewBattleTargetEndPage> {
  @override
  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          /// user1
          Positioned(
            left: 120,
            top: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/user_icon.png',
                  width: 102/2,
                  height: 117/2,
                ),
                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Player 1.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),


              ],
            ),
          ),
          /// user2
          Positioned(
            right: 120,
            top: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/user_icon.png',
                  width: 102/2,
                  height: 117/2,
                ),
                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Player 2.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),


              ],
            ),
          ),


          ///  user1的数据
          Positioned(
            left: 220,
            top: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularProgressIndicator(strokeWidth: 60,
                   color: Colors.red,

                ),

                Text(
                  '10',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '40%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(21, 233, 120, 1.0)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.leftTopSpeed}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.leftAvgSpeed}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(21, 233, 120, 1.0)),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),

          Positioned(
            left: 440,
            top: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shots In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Hit Rate',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Top Speed km/h',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Avg.Speed km/h',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),

          ///  user2的数据
          Positioned(
            right: 220,
            top: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '20',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '80%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(21, 233, 120, 1.0)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.rightTopSpeed}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.rightAvgSpeed}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(21, 233, 120, 1.0)),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),

          /// 退出
          Positioned(
            left: 40,
            bottom: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/exit.png',
                  width: 51/2,
                  height: 55/2,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Exit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),

              ],
            ),
          ),

          /// 重玩
          Positioned(
            right: 40,
            bottom: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Image.asset(
                  'assets/images/replay.png',
                  width: 51/2,
                  height: 55/2,
                ),
                const SizedBox(
                  width: 8,
                ),

                Text(
                  'Replay',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),

              ],
            ),
          ),
          /// 退出
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  color: Colors.white,
                ),
              ],
            ),
            left: 16,
            right: 16,
            top: 16,
          ),




        ],
      ),
    );
  }

}
