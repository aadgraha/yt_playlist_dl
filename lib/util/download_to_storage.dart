import 'dart:async';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:yt_playlist_dl/model/download.dart';
final baseUrl = 'http://127.0.0.1:8000';
// Future<void> downloadToStorage(String url, String mode) async {
//   try {
//   isLoading.value = true;
//   errorMessage.value = null;
//   final response = await dio.get(
//     "$baseUrl/download",
//     queryParameters: {"url": url, 'mode': mode},
//   );
//   final data = response.data as Map<String, dynamic>;
//   downloadItem.value = DownloadItem.fromJson(data);
//   } catch (e) {
//     errorMessage.value = e.toString();
//   } finally {
//     isLoading.value = false;
//   }
//   if (downloadItem.value != null) {
//   for (final file in downloadItem.value!.nameData) {
//     final folder = downloadItem.value!.id;
//     final fileUrl = "$baseUrl/file/$folder/${file.name}";
//   final dir = await getExternalStorageDirectory();
//   final savePath = "${dir!.path}/${file.name}";
//   await dio.download(
//     fileUrl,
//     savePath,
//     onReceiveProgress: (received, total) {
//       file.progress.value = received/total;
//       print(received/total);
//     },
//   );
//   }
//   }
// }

Future<void> downloadFiles(String url, String mode) async {
  final dio = Dio();
  try {
  isLoading.value = true;
  errorMessage.value = null;
  final response = await dio.get(
    "$baseUrl/download",
    queryParameters: {"url": url, 'mode': mode},
  );
  final data = response.data as Map<String, dynamic>;
  await pollFiles(folderId:   data['folder'] as String);
  } catch (e) {
    errorMessage.value = e.toString();
     print(e);
    throw Exception();
  } finally {
    isLoading.value = false;
    print(-1);
}
}
Timer? pollTimer;

Future<void> pollFiles({required String folderId}) async{
  final dio = Dio();
  pollTimer?.cancel();
  print('1');
  pollTimer = Timer.periodic(Duration(seconds: 1), (_) async {
    final res = await dio.get("$baseUrl/status/$folderId");
    print(res.data);
    final data = res.data as Map<String, dynamic>;
    updateProgress((data['files'] as List).map((json) => DownloadedFile.fromJson(json as Map<String, dynamic>)).toList());
    if (data["status"] == "completed" || data["status"] == "error") {
      pollTimer?.cancel();
      print('2');
    }
  });
}

void updateProgress(List<DownloadedFile> data) {
  print('3');
  downloadedFiles.value = data;
}

class DownloadedFile {
  final String name;
  final double progress;
  final String status;

  DownloadedFile({
    required this.name,
    required this.progress,
    required this.status,
  });

  factory DownloadedFile.fromJson(Map<String, dynamic> json) {
    return DownloadedFile(
      name: json['name'] as String,
      progress: (json['progress'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}

final downloadedFiles = Signal<List<DownloadedFile>>([]);