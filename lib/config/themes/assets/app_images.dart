import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

mixin AppImages {
  static const String _IMAGES_FOLDER_PATH = 'assets/images/';
  static const _appLogo = _IMAGES_FOLDER_PATH + 'logo.png';
  static const String _icDataNotFound =
      _IMAGES_FOLDER_PATH + 'il_pfa_activity_data_bank_not_found.svg';

  static Image icAppLogo({required double height, required double widget}) =>
      Image(
        width: widget,
        height: height,
        image: const AssetImage(
          _appLogo,
        ),
      );

  static SvgPicture icDataNotFound() => SvgPicture.asset(_icDataNotFound);
}
