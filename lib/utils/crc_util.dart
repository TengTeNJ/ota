
int crc16Update(List<int> src) {
  int crc = 0;
  for (int byte in src) {
    crc ^= byte << 8;
    for (int i = 0; i < 8; i++) {
      int temp = crc << 1;
      if ((crc & 0x8000) != 0) {
        temp ^= 0x1021;
      }
      crc = temp;
    }
  }
  return crc & 0xFFFF; // 确保结果为 16 位
}

/*
* 小端返回
* */
List<int> crc16Array(List<int> src) {
  int crc = 0;
  for (int byte in src) {
    crc ^= byte << 8;
    for (int i = 0; i < 8; i++) {
      int temp = crc << 1;
      if ((crc & 0x8000) != 0) {
        temp ^= 0x1021;
      }
      crc = temp;
    }
  }
  crc = crc & 0xFFFF;
  List<int> finalValue = [
    crc & 0xFF,       // 低位字节
    (crc >> 8) & 0xFF // 高位字节
  ];
  return finalValue; // 确保结果为 16 位
}