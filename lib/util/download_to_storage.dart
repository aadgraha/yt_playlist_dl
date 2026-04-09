import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadToStorage(String url, String mode) async {
  final dio = Dio();
  final baseUrl = 'http://127.0.0.1:8000';
  final response = await dio.get(
    "$baseUrl/download",
    queryParameters: {"url": url, 'mode': mode},
  );

  final folder = response.data['folder'];
  final fileNames = response.data["files"] as List;

  for (final fileName in fileNames) {
    final fileUrl = "$baseUrl/file/$folder/$fileName";
  final dir = await getExternalStorageDirectory();
  final savePath = "${dir!.path}/$fileName";

  await dio.download(
    fileUrl,
    savePath,
    onReceiveProgress: (received, total) {
      print("${(received / total * 100).toStringAsFixed(0)}%");
    },
  );
  print("Saved to: $savePath");
  }
}