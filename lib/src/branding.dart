import 'package:flutter/material.dart';

/// Contains branding options available for Veriff.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
class Branding {
  /// Color used for theme.
  String? themeColor;

  /// Color used for background.
  String? backgroundColor;

  /// Color used as status bar background.
  String? statusBarColor;

  /// Primary color used for texts.
  String? primaryTextColor;

  /// Secondary color used for texts.
  String? secondaryTextColor;

  /// Color used as primary button background.
  String? primaryButtonBackgroundColor;

  /// Corner radius value for buttons.
  int? buttonCornerRadius;

  /// Asset key string for custom logo to replace Veriff logos.
  AssetImage? logo;

  /// Asset key string for Android notification icon.
  String? androidNotificationIcon;

  /// Creates a [Branding] object.
  Branding(
      {String? themeColor,
      String? backgroundColor,
      String? statusBarColor,
      String? primaryTextColor,
      String? secondaryTextColor,
      String? primaryButtonBackgroundColor,
      int? buttonCornerRadius,
      AssetImage? logo,
      String? androidNotificationIcon}) {
    this.themeColor = themeColor;
    this.backgroundColor = backgroundColor;
    this.statusBarColor = statusBarColor;
    this.primaryTextColor = primaryTextColor;
    this.secondaryTextColor = secondaryTextColor;
    this.primaryButtonBackgroundColor = primaryButtonBackgroundColor;
    this.buttonCornerRadius = buttonCornerRadius;
    this.logo = logo;
    this.androidNotificationIcon = androidNotificationIcon;
  }

  /// Returns the [Branding] object as map.
  Map<String, dynamic> asMap() {
    return {
      "themeColor": this.themeColor,
      "backgroundColor": this.backgroundColor,
      "statusBarColor": this.statusBarColor,
      "primaryTextColor": this.primaryTextColor,
      "secondaryTextColor": this.secondaryTextColor,
      "primaryButtonBackgroundColor": this.primaryButtonBackgroundColor,
      "buttonCornerRadius": this.buttonCornerRadius,
      "logo": this.logo != null ? this.logo!.keyName : null,
      "androidNotificationIcon": this.androidNotificationIcon
    };
  }
}
