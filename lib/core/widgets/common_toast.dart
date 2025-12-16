
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../utils/adapt.dart';
import 'common_image.dart';

/// Title: CommonToast

class CommonToast {
  static CommonToast get instance => _getInstance();
  static CommonToast? _instance;

  static CommonToast _getInstance() {
    _instance ??= CommonToast._internal();
    return _instance!;
  }

  CommonToast._internal();

  /// Show Toast Message
  /// message: show word
  /// duration: existence time(milliseconds)

  Future<void> show(BuildContext? context, String message,
      {int duration = 2000, ToastType toastType = ToastType.normal}) async{
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    
    // Set indicator size to control icon widget size
    EasyLoading.instance.indicatorSize = Adapt.px(60);
    
    // Set widget and background color based on toast type
    final iconWidget = _getToastTypeIconName(toastType);
    switch (toastType) {
      case ToastType.success:
        EasyLoading.instance.successWidget = iconWidget;
        break;
      case ToastType.failed:
        EasyLoading.instance.errorWidget = iconWidget;
        break;
      case ToastType.info:
        EasyLoading.instance.infoWidget = iconWidget;
        break;
      case ToastType.normal:
        // No specific widget for normal type
        break;
    }
    
    EasyLoading.instance.backgroundColor = Colors.white;
    EasyLoading.instance.indicatorColor = Colors.transparent;
    EasyLoading.instance.textColor = Colors.white;
    EasyLoading.instance.radius = 20;
    EasyLoading.instance.contentPadding = EdgeInsets.all(
      34
    );

    EasyLoading.instance.boxShadow = [
      BoxShadow(
        color: Color(0xFF62748E).withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ];
    EasyLoading.instance.textStyle = GoogleFonts.inter(
      color: kTitleColor,
      fontSize: Adapt.px(16),
      fontWeight: FontWeight.w800,
    );
    
    // Show toast based on type
    switch (toastType) {
      case ToastType.normal:
        await EasyLoading.showToast(
          message,
          duration: Duration(milliseconds: duration),
        );
        break;
      case ToastType.success:
        await EasyLoading.showSuccess(
          message,
          duration: Duration(milliseconds: duration),
        );
        break;
      case ToastType.failed:
        await EasyLoading.showError(
          message,
          duration: Duration(milliseconds: duration),
        );
        break;
      case ToastType.info:
        await EasyLoading.showInfo(
          message,
          duration: Duration(milliseconds: duration),
        );
        break;
    }
  }

  Widget? _getToastTypeIconName(ToastType type) {
    String? iconName;
    switch (type) {
      case ToastType.normal:
        iconName = null;
        break;
      case ToastType.success:
        iconName = 'icon_toast_success.png';
        break;
      case ToastType.failed:
        iconName = 'icon_toast_failed.png';
        break;
      case ToastType.info:
        iconName = 'icon_toast_info.png';
        break;
    }
    if (iconName == null) {
      return null;
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        width: Adapt.px(60),
        height: Adapt.px(60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(60)),
          gradient: getBrandGradient(),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: Adapt.px(8),
              offset: Offset(0, Adapt.px(4)),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: CommonImage(
            iconName: iconName,
            width: Adapt.px(30),
            height: Adapt.px(30),
          ),
        ),
      );
    }
  }
}

enum ToastType { normal, success, failed, info }
