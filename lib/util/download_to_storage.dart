import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadToStorage(String url) async {
  final dio = Dio();
  final baseUrl = 'http://127.0.0.1:8000';

  // Step 1: request backend to download
  final response = await dio.get(
    "$baseUrl/download",
    queryParameters: {"url": url},
  );

  final filename = response.data["file"];

  // Step 2: get file URL
  final fileUrl = "$baseUrl/file/$filename";

  // Step 3: save to phone storage
  final dir = await getExternalStorageDirectory();
  final savePath = "${dir!.path}/$filename";

  await dio.download(
    fileUrl,
    savePath,
    onReceiveProgress: (received, total) {
      print("${(received / total * 100).toStringAsFixed(0)}%");
    },
  );

  print("Saved to: $savePath");
}