import 'package:flutter/material.dart';
import 'package:yt_playlist_dl/component/input_decoration.dart';
import 'package:yt_playlist_dl/component/nice_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(padding: EdgeInsets.all(15),children: [
            TextField(decoration: buildInputDecoration(label: 'Video ID')),
            SizedBox(height: 12,),
            NiceButton(text: 'Search', onPressed: (){})
          ],),
        )
      ),
    );
  }
}
