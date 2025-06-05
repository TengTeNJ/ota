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