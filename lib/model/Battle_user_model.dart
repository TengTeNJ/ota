class BattleUserModel {
    int score = 0; // 得分
    int shotInCount = 0; // 击中次数
    int topSpeed = 0; // 最快速度
    int avgSpeed = 0; // 平均速度
    bool isDraw = false; // 是否平局
    bool isWinner = false; // 是否是胜利者

    BattleUserModel({
      required this.score,
      required this.shotInCount,
      required this.topSpeed,
      required this.avgSpeed,
      required this.isWinner
   });
}