import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:yt_playlist_dl/model/download.dart';
import 'package:yt_playlist_dl/util/download_to_storage.dart';
import 'package:yt_playlist_dl/util/input_decoration.dart';
import 'package:yt_playlist_dl/util/labeled_checkbox.dart';
import 'package:yt_playlist_dl/util/nice_button.dart';

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
      child: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Column(
          children: [
            TextField(controller: urlController,decoration: buildInputDecoration(label: 'Video ID')),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(child: LabeledCheckbox(initialValue: audioOnlyCheck,label: 'Audio Only', onChanged: (value){if (value != null) {
                    audioOnlyCheck = value;
                  }} )),
              ],
            ),
            SizedBox(height: 12,),
            Watch((context) {
              return NiceButton(isLoading: isLoading.value,text: 'Get', onPressed: ()async {
              if (audioOnlyCheck) {
                mode = 'audio';
              } else {
                mode = 'video';
              }
            await downloadToStorage(urlController.text, mode);
            });
            }),
            SizedBox(height: 12,),
            Watch((context) {
              if (errorMessage.value != null) {
                return Text(errorMessage.value!);
              } 
              return SizedBox.shrink();
            }),
            Expanded(child: 
            Watch((context) {
              if (downloadItem.value == null) {return SizedBox.shrink();}
              return ListView.builder(itemCount: downloadItem.value!.nameData.length,itemBuilder: (context, index) {
                final title = downloadItem.value!.nameData[index].name;
                return Watch((context) {
                  final progress = downloadItem.value!.nameData[index].progress.value;
                  return ListTile(title: Text(title), subtitle: LinearProgressIndicator(value: progress, minHeight: 2,),);
                });
              });
            })
            )
          ],
        ),
      ),
    );
  }
}

//todo: list the playlist under get
//todo: make download parallel for playlist mode, that means once a file get downloaded in the back end, front end immediatelly donwload it