import 'package:signals/signals.dart';

enum DownloadStatus { idle, loading, downloading, done, error }

class NameData {
  final String name;
  final progress = signal(0.0);
  NameData ({required this.name});
}

class DownloadItem {
  final String id;
  final List<NameData> nameData;

  DownloadItem({
    required this.id,
    required this.nameData,
  });

   factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      id: json['folder']?.toString() ?? '',
      nameData: (json['files'] as List<dynamic>? ?? [])
          .map((e) => NameData(name: e.toString()))
          .toList(),
    );
  }
}

final isLoading = signal(false);
var downloadItem = signal<DownloadItem?>(null);
final errorMessage = signal<String?>(null);