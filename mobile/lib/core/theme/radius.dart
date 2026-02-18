import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const BorderRadius cardRadius = BorderRadius.only(
    topLeft: Radius.circular(28.0),
    topRight: Radius.circular(8.0),
    bottomLeft: Radius.circular(28.0),
    bottomRight: Radius.circular(28.0),
  );

  static const BorderRadius buttonRadius = BorderRadius.only(
    topLeft: Radius.circular(18.0),
    topRight: Radius.circular(4.0),
    bottomLeft: Radius.circular(18.0),
    bottomRight: Radius.circular(18.0),
  );
}
