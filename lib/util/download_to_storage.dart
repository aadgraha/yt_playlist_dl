import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yt_playlist_dl/model/download.dart';
final dio = Dio();
final baseUrl = 'http://127.0.0.1:8000';
Future<void> downloadToStorage(String url, String mode) async {
  try {
  isLoading.value = true;
  errorMessage.value = null;
  final response = await dio.get(
    "$baseUrl/download",
    queryParameters: {"url": url, 'mode': mode},
  );
  final data = response.data as Map<String, dynamic>;
  downloadItem.value = DownloadItem.fromJson(data);
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
  if (downloadItem.value != null) {
  for (final file in downloadItem.value!.nameData) {
    final folder = downloadItem.value!.id;
    final fileUrl = "$baseUrl/file/$folder/${file.name}";
  final dir = await getExternalStorageDirectory();
  final savePath = "${dir!.path}/${file.name}";
  await dio.download(
    fileUrl,
    savePath,
    onReceiveProgress: (received, total) {
      file.progress.value = received/total;
      print(received/total);
    },
  );
  }
  }
}