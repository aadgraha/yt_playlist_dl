import 'package:flutter/material.dart';
import 'package:yt_playlist_dl/page/download_page.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: DownloadPage()
      ),
    );
  }
}
