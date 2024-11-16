import 'package:flutter/material.dart';

class AppBorderRadius {
  static const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(100));
  static const BorderRadius topRounded = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
  static const BorderRadius bottomRounded = BorderRadius.only(
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );
}
