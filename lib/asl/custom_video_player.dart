import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/colors.dart';

class CustomVideoPlayer extends StatefulWidget {
  final Player player; // Receive the preloaded player
  final String videoName;
  final VoidCallback onDispose;

  const CustomVideoPlayer({
    Key? key,
    required this.player,
    required this.videoName,
    required this.onDispose,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final VideoController _videoController; // Initialize VideoController
  bool _isLoading = true; // Track loading state
  double _bufferingProgress = 0.0; // Track buffering progress

  @override
  void initState() {
    super.initState();

    // Create a video controller using the player
    _videoController = VideoController(widget.player);

    // Listen to the playing and buffering streams to update the UI
    widget.player.stream.playing.listen((isPlaying) {
      if (isPlaying) {
        setState(() {
          _isLoading = false; // Stop loading when video starts
        });
      }
    });

    // Listen for buffered updates
    widget.player.stream.buffer.listen((bufferedDuration) {
      final duration = widget.player.state.duration;

      if (duration != Duration.zero) {
        setState(() {
          // Calculate buffering progress using Duration in milliseconds
          _bufferingProgress = bufferedDuration.inMilliseconds / duration.inMilliseconds;
        });
      }
    });

    widget.player.stream.error.listen((error) {
      if (error != null) {
        print('Video Player Error: $error');
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the player when the widget is destroyed
    widget.player.dispose();
    widget.onDispose(); // Notify parent widget of disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade900,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVideoPlayer(),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _bufferingProgress, // This shows the buffering progress
              color: AppColors.primaryColor, // Customize the color as needed
              backgroundColor: Colors.black45, // Customize the background color as needed
            ),
            const SizedBox(height: 10),
            Text(
              widget.videoName,
              style: const TextStyle(
                fontFamily: 'Nastaliq',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), // Close the bottom sheet
              child: const Text('Close Video'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9, // Set the video aspect ratio
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while loading
          : Video(controller: _videoController), // Display the video
    );
  }
}
