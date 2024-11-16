import 'package:flutter/material.dart';
import 'package:sign_language_master/main.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var sentence = "Press the button and start speaking";

  @override
  void initState() {
    super.initState();

    checkconnection();

    read().then((value) {
      _getData();
    });
  }

  Future<void> checkconnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: const Center(
              child: Text('Something went wrong!! Please try again',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )));
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
    }
  }

  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> read() async {
    final dirPath = await _getDirPath();
    final myFile = File('$dirPath/speechoutput.json');
    final data = await myFile.readAsStringSync();

    final f_data = jsonDecode(data);
    setState(() {
      sentence = f_data["text"];
    });
  }

  void _getData() async {
    Map data = {"sentence": sentence};
    http.Response response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var result = response.body;
      var output_clips = json.decode(result);
      List<String> clips = [];
      for (var i = 0; i < output_clips.length; i++) {
        clips.add({
          "title": "${output_clips[i]}",
          "fileName": "assets/${output_clips[i]}.mp4",
          "thumbName": "Thumbnail.png",
          "runningTime": 3,
          "parent": "assets"
        } as String);
      }

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PlayPage(videoUrl: clips,sentence: sentence)),
      // );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: const Center(
              child: Text('Something went wrong!! Please try again',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )));
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Language'),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.25),
                  highlightColor: Colors.grey.withOpacity(0.6),
                  child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.withOpacity(0.9)))),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 26,
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.grey.withOpacity(0.6),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.9)),
                              ))),
                      Expanded(flex: 3, child: Text("")),
                      Expanded(
                          flex: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.25),
                                  highlightColor: Colors.grey.withOpacity(0.6),
                                  child: Container(
                                    height: 16,
                                    width: 220,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.withOpacity(0.9)),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.25),
                                highlightColor: Colors.grey.withOpacity(0.6),
                                child: Container(
                                  height: 16,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.withOpacity(0.9)),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                );
              },
            )
          ],
        ));
  }
}

class ApiConstants {
  static String baseUrl = 'http://ec2-54-147-236-46.compute-1.amazonaws.com';
  static String usersEndpoint = '/a2sl';
}
