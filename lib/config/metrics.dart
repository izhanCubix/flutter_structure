import 'dart:io';
import 'package:flutter/material.dart';

class Metrics {
  static late double screenWidth;
  static late double screenHeight;
  static late double statusBarHeight;
  static late double bottomPadding;

  static const double _guidelineBaseWidth = 375;
  static const double _guidelineBaseHeight = 812;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    statusBarHeight = mediaQuery.padding.top;
    bottomPadding = mediaQuery.padding.bottom;
  }

  static double scaleHorizontal(double size) =>
      (screenWidth / _guidelineBaseWidth) * size;

  static double scaleVertical(double size) =>
      (screenHeight / _guidelineBaseHeight) * size;

  static double ratio(
    double iosSize, [
    double? androidSize,
    bool doScale = false,
  ]) {
    final size = Platform.isAndroid ? (androidSize ?? iosSize) : iosSize;
    return doScale ? scaleVertical(size) : size;
  }

  static double generatedFontSize(
    double iosFontSize, [
    double? androidFontSize,
    bool doScale = false,
  ]) {
    final size = Platform.isAndroid
        ? (androidFontSize ?? iosFontSize)
        : iosFontSize;
    return doScale ? scaleVertical(size) : size;
  }

  static double get navbarHeight => Platform.isIOS ? 44 : 56;

  static double get navBarWithStatusHeight => navbarHeight + statusBarHeight;

  static double get bottomSpaceIphoneX => bottomPadding;

  static double get PDFHeight {
    if (Platform.isIOS) {
      return bottomPadding > 0 ? screenHeight * 0.5 : screenHeight * 0.47;
    } else {
      return screenHeight * 0.53;
    }
  }

  static double get createPasswordProgressBarWidth => (screenWidth - 63) / 4;

  static double get modalScreenHeight => screenHeight * 0.93;

  static double get baseMargin => ratio(16);
  static double get smallMargin => ratio(8);
  static double get midMargin => ratio(12);
  static double get largeMargin => ratio(20);

  static EdgeInsets get hitSlop => EdgeInsets.all(ratio(10));
  static EdgeInsets get hitSlopLarge => EdgeInsets.all(ratio(20));

  static double get bottomPaddingValue =>
      bottomPadding > 0 ? bottomPadding : ratio(20);

  static double get bottomPaddingIphoneXOnly =>
      bottomPadding > 0 ? bottomPadding : 0;

  static double get safeAreaSpacing => bottomPadding > 0 ? 0 : ratio(20);

  static double get tabBarHeight => ratio(98);

  static double get myLeaderboardContainerHeight =>
      bottomPadding > 0 ? ratio(86) : ratio(72);
}
