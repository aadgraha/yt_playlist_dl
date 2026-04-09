import 'package:flutter/material.dart';
import 'package:yt_playlist_dl/util/download_to_storage.dart';
import 'package:yt_playlist_dl/util/input_decoration.dart';
import 'package:yt_playlist_dl/util/labeled_checkbox.dart';
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
  var playlistCheck = false;
  var audioOnlyCheck = false;
  var mode = '';
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
        Row(
          children: [
            Expanded(child: LabeledCheckbox(initialValue: playlistCheck,label: 'Playlist', onChanged: (value){
              if (value != null) {
                playlistCheck = value;
               
              }
            } )),
            Expanded(child: LabeledCheckbox(initialValue: audioOnlyCheck,label: 'Audio Only', onChanged: (value){if (value != null) {
                audioOnlyCheck = value;
               
              }} )),
          ],
        ),
        SizedBox(height: 12,),
        NiceButton(text: 'Get', onPressed: ()async{
          if (playlistCheck == false && audioOnlyCheck == false) {
            mode = 'single_video';
          }
          if (playlistCheck == false && audioOnlyCheck == true) {
            mode = 'single_audio';
          }
          if (playlistCheck == true && audioOnlyCheck == false) {
            mode = 'playlist_video';
          }
          if (playlistCheck == true && audioOnlyCheck == true) {
            mode = 'playlist_audio';
          }
        //await downloadToStorage(urlController.text);
        })
      ],),
    );
  }
}
