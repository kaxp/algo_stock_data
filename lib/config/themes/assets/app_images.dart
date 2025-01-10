import 'package:flutter/material.dart';

mixin AppImages {
  static const String _IMAGES_FOLDER_PATH = 'assets/images/';
  static const _appLogo = _IMAGES_FOLDER_PATH + 'logo.png';

  static Image icAppLogo({required double height, required double widget}) =>
      Image(
        width: widget,
        height: height,
        image: const AssetImage(
          _appLogo,
        ),
      );
}
