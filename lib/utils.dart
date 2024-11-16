// utils.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static String toSentenceCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// Function that returns `true` if connected to the internet via mobile network or Wi-Fi, otherwise `false`.
  static Future<bool> isConnectedToInternet() async {
    try {
      // Use checkConnectivity() which returns a single ConnectivityResult
      List<ConnectivityResult> result =
          await Connectivity().checkConnectivity();

      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking connectivity: $e');
      return false; // In case of any error, assume no internet connection.
    }
  }

  // static Future<int> androidVersion() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     return androidInfo.version.sdkInt;
  // }

  // static Future<bool> requestStoragePermission() async {
  //
  //   //
  //   // if (Platform.isAndroid) {
  //   //   // For Android 11+ (API level 30+)
  //   //   if (await androidVersion() >= 30) {
  //   //     // Check if the permission is already granted
  //   //     print('Your are ask directly for storage permission');
  //   //   } else {
  //   //     // For Android versions lower than 11, request normal storage permission
  //   //     PermissionStatus status = await Permission.storage.request();
  //   //     if (status.isGranted) {
  //   //       print('Storage permission granted');
  //   //       return true; // Permission granted
  //   //     } else if (status.isDenied) {
  //   //       print('Storage permission denied');
  //   //       return false; // Permission denied
  //   //     } else if (status.isPermanentlyDenied) {
  //   //       openAppSettings(); // Guide the user to app settings
  //   //       return false; // Permission permanently denied
  //   //     }
  //   //   }
  //   // }
  //
  //   // Request Microphone Permission
  //   if (await Permission.microphone.isGranted) {
  //     print('Microphone permission is already granted');
  //     return true;
  //   }
  //   else {
  //     PermissionStatus mic = await Permission.microphone.request();
  //     if (mic.isGranted) {
  //       print('Microphone permission granted');
  //       return true;
  //     } else if (mic.isDenied) {
  //       print('Microphone permission denied');
  //       return false;
  //     } else if (mic.isPermanentlyDenied) {
  //       openAppSettings(); // Guide the user to app settings
  //     }
  //   }
  //
  //   return false; // Return false if we couldn't get the necessary permissions
  // }
}
