import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sign_language_master/utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:photo_manager/photo_manager.dart'; // Add this to your imports
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/border_radius.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class TextToVideo extends StatefulWidget {
  const TextToVideo({super.key});

  @override
  State<TextToVideo> createState() => _TextToVideoState();
}

class _TextToVideoState extends State<TextToVideo> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  bool _isRefreshLoading = false;
  String? _videoUrl;
  String videoName = '';
  late Player _player;
  bool _isInitialized = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";

  List<Map<String, String>> foundWords = [];
  List<Map<String, String>> foundMergedVideo = [];
  List<Map<String, String>> foundDownloadVideo = [];

  List<String> mainVideoLink = [];

  @override
  void initState() {
    _requestStoragePermission();
    getLocalVideos();
    _player = Player(); // Initialize the player once in initState
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition not available.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print("Speech recognition initialized successfully.");
      }
    } on PlatformException catch (e) {
      print("Error initializing speech: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _checkMicrophonePermission() async {
    if (await Permission.microphone.isGranted) {
      // Permission is granted, continue to speech recognition
      _toggleListening();
    } else {
      // Request permission
      PermissionStatus micPermission = await Permission.microphone.request();
      if (micPermission.isGranted) {
        _toggleListening();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Microphone permission denied. Please enable it in settings.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              _textController.text = _text;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _textController.text = _text;
    }
  }

  Future<void> _downloadVideoWithProgress(String url, File file) async {
    var request = http.Request('GET', Uri.parse(url));
    var response = await request.send();

    var totalBytes = response.contentLength ?? 0;
    var downloadedBytes = 0;

    var fileStream = file.openWrite();

    await response.stream.listen(
      (chunk) {
        fileStream.add(chunk);
        downloadedBytes += chunk.length;
      },
      onDone: () async {
        await fileStream.close();
        print('Downloaded $url to ${file.path}');
      },
      onError: (error) {
        print('Error downloading $url: $error');
      },
      cancelOnError: true,
    ).asFuture(); // Wait for the entire stream to finish
  }

  void _showLoadingDialog(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text(msg),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  color: AppColors.primaryColor), // Simple loader
              SizedBox(height: 10),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Dismiss the dialog
    }
  }

  Future<void> _initializeController(String url) async {
    try {
      await _player.open(Media(url)); // Open the video URL
      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      print('Error initializing video player: $error');
    }
  }

  Future<String?> getVideoUrl(String videoPath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(videoPath);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Failed to fetch video URL: $e');
      return null;
    }
  }

  String _convertToFormattedName(String input) {
    // Convert to lowercase and split into words
    List<String> words = input.toLowerCase().split(' ');

    // Capitalize the first letter of each word
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).toList();

    // Join the words with underscores
    return capitalizedWords.join('_');
  }

  Future<String?> getVideoAssetPath(String assetPath) async {
    try {
      // Attempt to load the asset to verify its existence
      ByteData data = await rootBundle.load(assetPath);
      if (data.lengthInBytes > 0) {
        return assetPath; // Return the asset path if it exists
      }
    } catch (e) {
      // Asset does not exist
      return null;
    }
    return null;
  }

  Future<void> _checkWordsAndLetters(String text) async {
    List<Map<String, String>> tempVideoList = [];

    // Split the input text into words
    List<String> words = text.split('_');

    for (String word in words) {
      String sentenceCaseWord = word;
      String? wordPath =
          await getVideoAssetPath('assets/Videos/$sentenceCaseWord.mp4');

      // Check if the word video exists in assets
      if (wordPath != null) {
        tempVideoList.add({'name': sentenceCaseWord, 'url': wordPath});
        mainVideoLink.add(wordPath);
      } else {
        // If word video does not exist, check each letter
        for (String letter in sentenceCaseWord.split('')) {
          String capitalLetter = letter.toUpperCase();
          String? letterPath =
              await getVideoAssetPath('assets/Videos/$capitalLetter.mp4');
          if (letterPath != null) {
            tempVideoList.add({'name': capitalLetter, 'url': letterPath});
            mainVideoLink.add(letterPath);
          }
        }
      }
    }

    setState(() {
      foundWords = tempVideoList; // Store found videos for words
      _isLoading = false;
    });
  }

  Future<void> _onSendButtonPressed() async {
    setState(() {
      _isInitialized = false;
    });
    videoName = _textController.text.trim();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory mergedDir = Directory(path.join(appDocDir.path, 'MergedVideos'));
    if (videoName.isNotEmpty) {
      setState(() {
        _videoUrl = null;
        _isLoading = true;
        foundWords = [];
        mainVideoLink = [];
      });
      // Convert to sentence case and replace spaces with underscores
      String formattedVideoName = _convertToFormattedName(videoName);
      videoName = formattedVideoName.replaceAll('_', ' ');

      // Paths for merged video
      String mergedVideoPath = path.join(mergedDir.path, formattedVideoName);
      File mergedVideoFile = File(mergedVideoPath);

      // Check if merged video already exists locally
      if (await mergedVideoFile.exists()) {
        _playVideo(mergedVideoPath, videoName);
        return; // Exit if the video exists
      }

      await _checkWordsAndLetters(formattedVideoName);

      if (foundWords.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No video found for any words or letters.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        mergeVideos(mainVideoLink, videoName);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> getLocalVideos() async {
    setState(() {
      _isRefreshLoading = true; // Start loading
      foundMergedVideo = [];
    });

    try {
      // Request storage permission if not already granted
      if (!(await _requestStoragePermission())) {
        print("Permission to access storage denied.");
        return;
      }

      // Define the path for the "Sign_Videos" directory
      Directory publicDir = Directory('/storage/emulated/0/Movies/Sign_Videos');

      // Check if the "Sign_Videos" directory exists
      if (!(await publicDir.exists())) {
        print("Sign_Videos directory does not exist.");
        return;
      }

      List<Map<String, String>> foundMergedFiles = [];

      try {
        // List all video files in the "Sign_Videos" directory
        List<FileSystemEntity> mergedFiles = publicDir.listSync();

        for (var file in mergedFiles) {
          if (file is File && file.path.endsWith('.mp4')) {
            String fileName = path.basenameWithoutExtension(file.path);
            String displayName = fileName.replaceAll('_', ' '); // Format name

            // Add video information to the list
            foundMergedFiles.add({'name': displayName, 'path': file.path});
          }
        }

        // Update the state with the found videos
        setState(() {
          foundMergedVideo.addAll(foundMergedFiles);
          _textController.clear(); // Clear the text after sending
          FocusScope.of(context).unfocus();
        });

        print('Found ${foundMergedFiles.length} videos in Sign_Videos folder.');
      } catch (e) {
        print('An error occurred while accessing videos: $e');
      }
      await Future.delayed(const Duration(seconds: 1)); // Example delay
    } finally {
      setState(() {
        _isRefreshLoading = false; // Stop loading
      });
    }
  }

  Future<void> mergeVideos(
      List<String> assetVideoPaths, String videoName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Request storage permissions
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Storage permission not granted');
        return;
      }

      String formattedVideoName = _convertToFormattedName(videoName);
      String outputFileName = '$formattedVideoName.mp4';

      Directory? appDocDir = await getExternalStorageDirectory();

      Directory publicDir = Directory('/storage/emulated/0/Movies/Sign_Videos');
      if (!await publicDir.exists()) {
        await publicDir.create(recursive: true);
      }

      String mergedVideoPath = path.join(publicDir.path, outputFileName);
      File mergedVideoFile = File(mergedVideoPath);

      if (await mergedVideoFile.exists()) {
        _playVideo(mergedVideoPath, videoName);
        return;
      }

      List<String> preprocessedVideoPaths = [];

      for (int i = 0; i < assetVideoPaths.length; i++) {
        String assetPath = assetVideoPaths[i];
        String localFilePath = path.join(appDocDir?.path ?? '', 'video_$i.mp4');
        File localVideoFile = File(localFilePath);

        print("Copying video from assets: $assetPath");
        ByteData byteData = await rootBundle.load(assetPath);
        await localVideoFile.writeAsBytes(byteData.buffer.asUint8List());

        if (!await localVideoFile.exists()) {
          print("Failed to copy video from assets to: $localFilePath");
          continue;
        } else {
          print("Successfully copied video to: $localFilePath");
        }

        String preprocessedFilePath =
            path.join(appDocDir!.path, 'preprocessed_video_$i.mp4');

        // Simplified preprocessing command
        final String preprocessCommand =
            '-i $localFilePath -vf scale=1280:720 $preprocessedFilePath';

        print(
            "Starting preprocessing for: $localFilePath with command: $preprocessCommand");
        final preprocessSession = await FFmpegKit.execute(preprocessCommand);
        final preprocessReturnCode = await preprocessSession.getReturnCode();
        final ffmpegLogs = await preprocessSession.getLogs();

        if (ReturnCode.isSuccess(preprocessReturnCode) &&
            await File(preprocessedFilePath).exists()) {
          preprocessedVideoPaths.add(preprocessedFilePath);
          print("Successfully preprocessed video: $preprocessedFilePath");
        } else {
          print("Failed to preprocess video: $assetPath");
          ffmpegLogs.forEach((log) => print("FFmpeg Log: ${log.getMessage()}"));
        }
      }

      if (preprocessedVideoPaths.isEmpty) {
        print("No videos were preprocessed successfully. Exiting.");
        return;
      }

      String fileListContent = preprocessedVideoPaths
          .map((filePath) => "file '${filePath.replaceAll("'", "\\'")}'")
          .join('\n');
      File videoListFile = File(path.join(appDocDir!.path, 'video_list.txt'));
      await videoListFile.writeAsString(fileListContent);

      if (!await videoListFile.exists()) {
        print("Video list file not created: ${videoListFile.path}");
        return;
      }

      final String mergeCommand =
          '-f concat -safe 0 -i ${videoListFile.path} -c copy $mergedVideoPath';

      print("Starting merge command...");
      final session = await FFmpegKit.execute(mergeCommand);
      final returnCode = await session.getReturnCode();
      final mergeLogs = await session.getLogs();

      if (ReturnCode.isSuccess(returnCode)) {
        if (await mergedVideoFile.exists()) {
          await _notifyGallery(mergedVideoPath);
          _playVideo(mergedVideoPath, videoName);
          await _cleanupLocalFiles(preprocessedVideoPaths);
          await _cleanupLocalFiles([videoListFile.path]);
          getLocalVideos();
        } else {
          print("Merged video not found at: $mergedVideoPath");
        }
      } else {
        print('Error merging videos: $returnCode');
        mergeLogs.forEach((log) => print("FFmpeg Log: ${log.getMessage()}"));
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      _hideLoadingDialog();
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Delete temporary local files after merging.
  Future<void> _cleanupLocalFiles(List<String> filePaths) async {
    for (String filePath in filePaths) {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 11+ (API 30+)
      if (await Permission.manageExternalStorage.isDenied ||
          await Permission.storage.isDenied) {
        var manageStatus = await Permission.manageExternalStorage.request();
        var storageStatus = await Permission.storage.request();

        if (manageStatus.isGranted || storageStatus.isGranted) {
          return await _requestPhotoPermissions();
        } else {
          print('Storage permission denied.');
          return false;
        }
      }
      // For Android 10 and below
      else if (await Permission.storage.isDenied) {
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // Assume permission is granted on non-Android platforms
  }

// Request access to photos using photo_manager (across Android versions)
  Future<bool> _requestPhotoPermissions() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();

    if (!result.isAuth) {
      print('Permission to access photos denied. Current state: $result');
      return false;
    }
    print('Photo permissions granted.');
    return true;
  }

// Notify the gallery about the new video
  Future<void> _notifyGallery(String filePath) async {
    try {
      await Process.run('am', [
        'broadcast',
        '-a',
        'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d',
        'file://$filePath'
      ]);
      print('Gallery notified for $filePath');
    } catch (e) {
      print('Error notifying gallery: $e');
    }
  }

// Upload video to Firestore
  Future<void> uploadVideoToFirestore(File videoFile, String fileName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Videos/$fileName');
      await ref.putFile(videoFile);
      print('Uploaded $fileName to Firestore Storage.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Videos Uploaded: ' + fileName.split(".")[0]),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to upload video: $e');
    }
  }

  void _playVideo(String url, String name) async {
    // Clear current video state and set loading to true
    setState(() {
      if (_isInitialized) {
        _isInitialized = false;
        _player
            .dispose(); // Dispose the player immediately if already initialized
      }
      _videoUrl = null;
      videoName = '';
      _isLoading = true;
    });

    // Format and set the video name
    String formattedVideoName = _convertToFormattedName(name);
    videoName = formattedVideoName.replaceAll('_', ' ');

    // Check if the URL is valid before proceeding
    if (url.isNotEmpty) {
      _videoUrl = url;
      try {
        // Initialize the controller with the new URL and handle loading state
        await _initializeController(_videoUrl!);
        setState(() {
          _isInitialized = true; // Set initialization flag once initialized
          _isLoading = false; // Loading completed
        });
      } catch (error) {
        // Handle errors during initialization
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
      // Handle cases where the URL is invalid or empty
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

  Widget _buildWordsGrid() {
    if (foundWords.isEmpty) return SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.5,
      ),
      itemCount: foundWords.length,
      itemBuilder: (context, index) {
        final videoData = foundWords[index];
        return GestureDetector(
          onTap: () {
            // _playVideo(videoData['url']!, videoData['name']!);
          },
          child: Card(
            color: AppColors.primaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  videoData['name']!,
                  style: AppTextStyles.smallText,
                  textAlign: TextAlign.center,
                  softWrap: true, // Enables soft wrapping for long text
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // Specify width (optional)
      quality: 75, // Thumbnail quality (0-100)
    );
  }

  Widget _buildMergedGrid() {
    if (foundMergedVideo.isEmpty) return SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.75, // Adjust to fit thumbnail + text
      ),
      itemCount: foundMergedVideo.length,
      itemBuilder: (context, index) {
        final videoData = foundMergedVideo[index];
        return FutureBuilder<String?>(
          future: _getThumbnail(videoData['path']!),
          builder: (context, snapshot) {
            // Check if merged video list is empty again here (edge case)
            if (foundMergedVideo.isEmpty) {
              return SizedBox.shrink(); // Don't show anything
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _isInitialized = false;
                });
                _playVideo(videoData['path']!, videoData['name']!);
              },
              child: Card(
                color: AppColors.primaryColor,
                child: Column(
                  children: [
                    Expanded(
                      child: snapshot.data != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.file(
                                File(snapshot.data!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Icon(
                              Icons.videocam,
                              color: AppColors.textColor,
                              size: 50,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        videoData['name']!,
                        style:
                            AppTextStyles.mediumHeading.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                        softWrap: true, // Enables soft wrapping for long text
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoUrl == null) return SizedBox.shrink();

    return Container(
      decoration: const BoxDecoration(
        borderRadius: AppBorderRadius.defaultRadius,
      ),
      child: _isInitialized
          ? AspectRatio(
              aspectRatio: 16 / 9, // Set the aspect ratio for the video player
              child: Video(
                controller: VideoController(
                    _player), // Pass the player to the controller
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_videoUrl != null)
                      Card(
                        color: AppColors.primaryColor,
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.defaultRadius,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            _buildVideoPlayer(),
                            const SizedBox(height: 20),
                            Text(videoName,
                                style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    else
                      Card(
                        color: AppColors.primaryColor,
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.defaultRadius,
                        ),
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Center content within the card
                              children: [
                                const Icon(
                                  Icons
                                      .videocam_rounded, // Video placeholder icon
                                  size: 64, // Adjust size as needed
                                  color: AppColors
                                      .accentColor, // Optional: Style the icon
                                ),
                                const SizedBox(
                                    height:
                                        12), // Add space between the icon and text
                                Text(
                                  "Write any word to fetch video.",
                                  style: AppTextStyles.mediumHeading.copyWith(
                                    color: AppColors.textColor,
                                  ), // Reuse text style with customization
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_isLoading) ...{
                      SizedBox(height: 10),
                      const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor),
                      ),
                    },
                    if (!foundWords.isEmpty) ...{
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Words in sentence",
                                style: AppTextStyles.mediumHeading),
                            Icon(Icons.volume_up),
                          ],
                        ),
                      ),
                      _buildWordsGrid()
                    },
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("My Recent Videos",
                              style: AppTextStyles.mediumHeading),
                          InkWell(
                            onTap: () {
                              getLocalVideos();
                            },
                            child: _isRefreshLoading
                                ? const SizedBox(
                                    height: 16, // Same size as icon
                                    width: 16, // Set width to match height
                                    child: CircularProgressIndicator(
                                      strokeWidth:
                                          2, // Adjust thickness to fit the icon size
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh,
                                    color: AppColors.primaryColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!foundMergedVideo.isEmpty) ...{
                      _buildMergedGrid()
                    } else ...{
                      const Center(
                        child: Text(
                          'No Recent Videos Found!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: AppColors.primaryColor),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: AppBorderRadius.defaultRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTextStyles
                          .mediumHeading, // Apply style to input text
                      decoration: const InputDecoration(
                        hintText: 'Type to translate',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.record_voice_over : Icons.mic,
                      size: 30,
                    ),
                    onPressed: () async {
                      await _checkMicrophonePermission(); // Check permission before starting
                    },
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  IconButton(
                      icon: const Icon(Icons.send_rounded, size: 30),
                      onPressed: () async {
                        // Hide the keyboard
                        setState(() {
                          FocusScope.of(context).unfocus();
                        });

                        bool isConnected = await Utils.isConnectedToInternet();
                        if (isConnected) {
                          _onSendButtonPressed();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not connected to the internet.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listen({Function(String)? onTextChanged}) async {
    if (!_isListening) {
      try {
        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );

        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              setState(() {
                _text = val.recognizedWords;
              });
              if (onTextChanged != null) {
                onTextChanged(val.recognizedWords);
              }
            },
          );
        }
      } catch (e) {
        print('Error initializing speech recognition: $e');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      //await storeOutput();
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    if (await Permission.microphone.request().isGranted) {
      String dialogText = _text;
      bool dialogListening = _isListening;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.mic, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Speech Control'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Recognized Speech:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        dialogText,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      dialogListening
                          ? AvatarGlow(
                              animate: true,
                              glowColor: Theme.of(context).primaryColor,
                              endRadius: 50.0,
                              duration: const Duration(milliseconds: 2000),
                              repeatPauseDuration:
                                  const Duration(milliseconds: 100),
                              repeat: true,
                              child: FloatingActionButton(
                                onPressed: () {
                                  setStateDialog(() {
                                    dialogListening = false;
                                  });
                                  _listen(onTextChanged: (newText) {
                                    setStateDialog(() {
                                      dialogText = newText;
                                    });
                                  });
                                },
                                child: const Icon(Icons.record_voice_over),
                              ),
                            )
                          : FloatingActionButton(
                              onPressed: () {
                                setStateDialog(() {
                                  dialogListening = true;
                                });
                                _listen(onTextChanged: (newText) {
                                  setStateDialog(() {
                                    dialogText = newText;
                                  });
                                });
                              },
                              child: const Icon(Icons.mic),
                            ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        dialogListening = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _textController.text = dialogText;
                        dialogListening = false;
                      });

                      Navigator.of(context).pop();

                      //await storeOutput();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission Denied'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
