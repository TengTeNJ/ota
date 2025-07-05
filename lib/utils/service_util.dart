import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


import 'package:dio/dio.dart';

import 'comm_statu_manager.dart';

Future<void> downloadWithDio() async {
  final dio = Dio();
  final url = 'https://potent-hockey-us.s3.us-east-1.amazonaws.com/images/20250604/e452450fff07482d98fe8457878e5d9b.bin';
  try {
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: (received, total) {
        print('进度: ${(received / total * 100).toStringAsFixed(0)}%');
      },
    );

    if (response.statusCode == 200) {
      final bytes = response.data as List<int>;
      // 保存文件...
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      print('Dio: 连接超时');
    } else {
      print('Dio错误: $e');
    }
  }
}

Future<bool> downloadAndConvertBin(String url) async {
  try {
    // 1. 下载文件到内存
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      CommStatusManager().loadBinFile();
      return false;
      throw Exception('下载失败: HTTP ${response.statusCode}');
    }

    // 2. 将响应体直接转换为 ByteData
    final bytes = response.bodyBytes;
    final byteData = ByteData.view(bytes.buffer);

    await _saveToFile(bytes);
    CommStatusManager().loadBinFile();
    return true;

    // 可选：如果需要保存到本地文件
    await _saveToFile(bytes);
  } catch (e) {
    CommStatusManager().loadBinFile();


    return false;
    throw Exception('处理失败: $e');
  }
}

// 可选：保存到本地文件的辅助方法
Future<void> _saveToFile(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File(path.join(dir.path, 'downloaded.bin'));
  await file.writeAsBytes(bytes);
  print('文件已保存到: ${file.path}');
}

// 将整数转换为两个字节
List<int> intToBytes(int value) {
  // 提取高8位（右移8位）
  final highByte = (value >> 8) & 0xFF;
  // 提取低8位
  final lowByte = value & 0xFF;
  return [highByte, lowByte];
}

int calculatePercentage(int part, int whole) {
  if (whole == 0) return 0; // 避免除以零
  return ((part / whole) * 100).round();
}

int calculateScopePercentage(int part, int whole) {
  if (whole == 0) return 0; // 避免除以零

  int percent = ((part / whole) * 100).round();

  if (percent >= 30 && percent < 50) return 40;
  if (percent >= 50 && percent < 70) return 60;
  if (percent >= 70 && percent < 90) return 80;
  if (percent >= 90 && percent <= 110) return 100;
  if (percent > 110 && percent <= 130) return 120;

  return percent;
}

