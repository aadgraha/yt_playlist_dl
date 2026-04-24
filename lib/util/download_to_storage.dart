import 'dart:async';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:yt_playlist_dl/model/download.dart';

final baseUrl = 'http://127.0.0.1:8000';

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
    await pollFiles(folderId: data['folder'] as String);
  } catch (e) {
    errorMessage.value = e.toString();
    throw Exception();
  } finally {
    isLoading.value = false;
  }
}

Timer? pollTimer;

Future<void> pollFiles({required String folderId}) async {
  final dio = Dio();
  pollTimer?.cancel();
  pollTimer = Timer.periodic(Duration(seconds: 1), (_) async {
    final res = await dio.get("$baseUrl/status/$folderId");
    final data = res.data as Map<String, dynamic>;
    final updatedData = (data['files'] as List)
        .map((json) => DownloadedFile.fromJson(json as Map<String, dynamic>))
        .toList();
    final swappedData = swapByMatch<DownloadedFile>(
      updatedData,
      downloadedSet,
      (e1, e2) => e1.name == e2.name,
    );
    updateProgress(folderId, swappedData);
    if (data["status"] == "completed" || data["status"] == "error") {
      pollTimer?.cancel();
    }
  });
}

void updateProgress(String folderId, List<DownloadedFile> files) {
  final updated = files.map((e) {
    if (e.status == 'finished' && !downloadedSet.contains(e)) {
      downloadFile(folderId, e);
    }
    return DownloadedFile(name: e.name, status: e.status, progress: e.progress);
  }).toList();
  downloadedFiles.value = updated;
}

class DownloadedFile {
  final String name;
  final double progress;
  final String status;
  final progressDownload = Signal<double>(0.0);
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

Future<void> downloadFile(String folderId, DownloadedFile file) async {
  try {
    final dio = Dio();
    final fileUrl = "$baseUrl/file/$folderId/${file.name}";
    final dir = await getExternalStorageDirectory();
    final savePath = "${dir!.path}/${file.name}";
    await dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (received, total) {
        file.progressDownload.value =
            (0.5 * file.progress) + (0.5 * (received / total));
        print('${(0.5 * file.progress)} + ${(0.5 * (received / total))}');
      },
    );
    downloadedSet.add(file);
    print(downloadedSet.map((e) => e.progressDownload.value));
  } catch (e) {
    throw Exception(e);
  }
}

final downloadedFiles = Signal<List<DownloadedFile>>([]);
final downloadedSet = <DownloadedFile>{};

List<T> swapByMatch<T>(
  List<T> list,
  Set<T> setList,
  bool Function(T listObj, T setObj) matcher,
) {
  List<T> result = List.from(list);

  for (int i = 0; i < result.length; i++) {
    final match = setList
        .where((setObj) => matcher(result[i], setObj))
        .firstOrNull;
    if (match != null) {
      result[i] = match;
    }
  }

  return result;
}
