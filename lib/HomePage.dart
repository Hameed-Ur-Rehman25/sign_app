import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'asl/audio_record.dart';
import 'asl/text_to_video.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // Minimize the app//Navigator.of(context).pop(true), // Exit the app
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      onWillPop: _onWillPop, // Attach the back button press handler
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext contesxt) {
                  return [
                    const PopupMenuItem(
                      value: "About Us",
                      child: Text("About Us"),
                    ),
                    const PopupMenuItem(
                      value: "Settings",
                      child: Text("Settings"),
                    ),
                  ];
                },
              )
            ],
            bottom: TabBar(
              indicator: BoxDecoration(
                color: Colors.indigoAccent, // Background color for the selected tab
                borderRadius: BorderRadius.circular(5), // Optional, rounded corners
              ),
              indicatorSize: TabBarIndicatorSize.tab, // Full width of the selected tab
              labelColor: Colors.white, // White color for selected tab icons
              unselectedLabelColor: Colors.grey, // Grey color for unselected tab icons
              tabs: const [
                Tooltip(
                  message: "Audio to Sign Language",
                  child: Tab(
                    icon: Icon(Icons.video_call_sharp),
                  ),
                ),
                Tooltip(
                  message: "Stories",
                  child: Tab(
                    icon: Icon(Icons.collections_bookmark_sharp),
                  ),
                ),
              ],
            ),
            title: const Text('SignMate'),
          ),
          body: const TabBarView(
            children: [
              TextToVideo(),
              AudioRecord(),
            ],
          ),
        ),
      ),
    );
  }
}
