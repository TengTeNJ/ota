class NtrpDataModel {
  /// 第一阶段结算显示的数据
  int forehand = 0; // Forehand
  int forehandAvgSpeed = 0; // forehandAvgSpeed
  int backhand = 0; // Backhand
  int backhandAvgSpeed = 0; // backhandAvgSpeed
  int volley = 0; // Volley

  /// 第二阶段结算显示的数据
  int powerControlCount = 0; // powerControlCount
  int powerControlAvgSpeed = 0; // powerControlAvgSpeed
  int moveShotsIn = 0; // moveShotsIn
  int moveShotsInAvgSpeed = 0; // moveShotsIn




  // NtrpDataModel({
  //   this.forehand = 0,
  //   required this.backhand,
  //   required this.volley,
  // });

  NtrpDataModel({
     this.forehand = 0,
     this.forehandAvgSpeed = 0,
     this.backhand = 0,
     this.backhandAvgSpeed = 0,
     this.volley =0,

    this.powerControlCount = 0,
    this.powerControlAvgSpeed = 0,
    this.moveShotsIn = 0,
    this.moveShotsInAvgSpeed = 0,
  });
}