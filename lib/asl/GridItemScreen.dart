import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player/video_player.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';
import 'custom_video_player.dart';

class GridItemScreen extends StatefulWidget {
  final String title;
  final List<Map<String, String>> items;

  const GridItemScreen({super.key, required this.title, required this.items});

  @override
  _GridItemScreenState createState() => _GridItemScreenState();
}

class _GridItemScreenState extends State<GridItemScreen> {
  late VideoPlayerController _controller;
  String? selectedVideo;

  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showVideoPlayer(BuildContext context, String path, String name) {
    final player = Player(); // Create player instance

    player.open(Media('asset:///$path')); // Load video from Firestore
    //mute the player
    player.setVolume(0.0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      isDismissible: false, // Prevent dismissing by tapping outside
      enableDrag: false, // Disable swipe to dismiss
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CustomVideoPlayer(
          player: player,
          videoName: name,
          onDispose: () {
            print('Player disposed'); // For debugging
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (widget.title != "Urdu Alphabets" && widget.title != "Colors Category" && widget.title != "Fruits Category") ...{
                  Text(
                    widget.title,
                    style: AppTextStyles.mainHeading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 6 : 3, // Responsive grid
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return GestureDetector(
                          onTap: () {
                            _showVideoPlayer(
                              context,
                              item['path']!,
                              item['name'] ?? 'Unnamed Video',
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  item['thumbnail'] ?? 'assets/signlanguage.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.fitHeight,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                } else ...{
                  if(widget.title == "Urdu Alphabets")...{
                    Text(
                      "اُردُو حُرُوفِ تَہَجِّی‌",
                      style: AppTextStyles.mainHeading.copyWith(
                        fontFamily: 'Nastaliq', // Apply Nastaliq font
                      ),
                      textAlign: TextAlign.center,
                    ),
                  }else ...{
                    Text(
                      widget.title,
                      style: AppTextStyles.mainHeading,
                      textAlign: TextAlign.center,
                    ),
                  },

                  const SizedBox(height: 16),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl, // Set the direction to RTL
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 600 ? 6 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return GestureDetector(
                            onTap: () {
                              _showVideoPlayer(
                                context,
                                item['path']!,
                                item['name'] ?? 'Unnamed Video',
                              );
                            },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(widget.title == "Urdu Alphabets")...{
                                      Text(
                                        item['name']!,
                                        style: AppTextStyles.mainHeading.copyWith(
                                          fontFamily: 'Nastaliq', // Apply Nastaliq font
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    }else ...{
                                      Text(
                                        item['name']!,
                                        style: AppTextStyles.mediumHeading,
                                        textAlign: TextAlign.center,
                                      ),
                                    },
                              
                              
                                  ],
                                ),
                              ),

                          );
                        },
                      ),
                    ),
                  ),
                },
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Floating Back Button Positioned in Bottom-Right
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context), // Go back on tap
              child: const Icon(Icons.arrow_back),
              backgroundColor: AppColors.primaryColor, // Customize color if needed
            ),
          ),
        ],
      ),
    );
  }

}
