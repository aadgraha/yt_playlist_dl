import 'package:flutter/material.dart';
import 'package:yt_playlist_dl/util/download_to_storage.dart';
import 'package:yt_playlist_dl/util/input_decoration.dart';
import 'package:yt_playlist_dl/util/nice_button.dart';

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

class DownloadPage extends StatefulWidget {
  const DownloadPage({
    super.key,
  });

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final urlController = TextEditingController();
  @override void dispose() {
    urlController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: EdgeInsets.all(15),children: [
        TextField(controller: urlController,decoration: buildInputDecoration(label: 'Video ID')),
        SizedBox(height: 12,),
        NiceButton(text: 'Search', onPressed: ()async{
        await downloadToStorage(urlController.text);
        })
      ],),
    );
  }
}
