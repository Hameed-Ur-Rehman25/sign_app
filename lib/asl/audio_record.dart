import 'package:flutter/material.dart';
import 'package:sign_language_master/asl/loading.dart';
import 'speech_screen.dart';



class AudioRecord extends StatefulWidget{
  const AudioRecord({ super.key });


  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

      body: Center(child: SpeechScreen()),

      // floatingActionButton: FloatingActionButton.extended(
      //   heroTag: 'translatebtn',
      //   onPressed: ()
      //   {
      //
      //     {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => Loading()),
      //       );
      //     }
      //
      //   }
      //   ,
      //   icon : Icon(Icons.play_arrow),
      //   label: Text('Translate'),
      //   tooltip: "Translate",
      // ),
    );
  }
}

