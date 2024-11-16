import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayPage extends StatefulWidget {
  final String videoUrl;
  final String sentence;

  const PlayPage({Key? key, required this.videoUrl, required this.sentence})
      : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late Player _player;
  bool _isInitialized = false;
  bool _isLoading = false;
  String videoName = '';

  @override
  void initState() {
    super.initState();
    _player = Player();
    _playVideo(widget.videoUrl);
  }

  Future<void> _playVideo(String url) async {
    setState(() {
      videoName = '';
      _isLoading = true;
    });

    if (url.isNotEmpty) {
      try {
        // Dispose the previous player instance if already initialized
        if (_isInitialized) {
          _player.dispose();
          _isInitialized = false;
        }

        await _initializeController(url);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading video: ${error.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video not found. Try another word.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeController(String url) async {
    try {
      await _player.open(Media(url));
      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      print('Error initializing video player: $error');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized) return SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Video(controller: VideoController(_player)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(videoName),
      ),
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : _buildVideoPlayer(),
      ),
    );
  }
}
