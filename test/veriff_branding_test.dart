import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/src/branding.dart';

void main() {
  Branding? branding;

  tearDown(() {
    branding = null;
  });

  test("Test Branding is created with only themeColor", () async {
    String testThemeColor = "test-color";
    branding = Branding(themeColor: testThemeColor);
    expect(branding?.themeColor, testThemeColor);
    expect(branding?.backgroundColor, null);
    expect(branding?.statusBarColor, null);
    expect(branding?.primaryTextColor, null);
    expect(branding?.secondaryTextColor, null);
    expect(branding?.primaryButtonBackgroundColor, null);
    expect(branding?.buttonCornerRadius, null);
    expect(branding?.logo, null);
    expect(branding?.androidNotificationIcon, null);
  });

  test("Test Branding is created with only buttonCornerRadius", () async {
    int testButtonCornerRadius = 5;
    branding = Branding(buttonCornerRadius: testButtonCornerRadius);
    expect(branding?.buttonCornerRadius, testButtonCornerRadius);
    expect(branding?.backgroundColor, null);
    expect(branding?.statusBarColor, null);
    expect(branding?.primaryTextColor, null);
    expect(branding?.secondaryTextColor, null);
    expect(branding?.primaryButtonBackgroundColor, null);
    expect(branding?.themeColor, null);
    expect(branding?.logo, null);
    expect(branding?.androidNotificationIcon, null);
  });

  test("Test Branding is created correctly", () async {
    String testColor = "#ff0000";
    int testButtonCornerRadius = 5;
    AssetImage? testAssetImage = AssetImage("test-image");
    String testAndroidNotificationIcon = "test-image";
    branding = Branding(
      themeColor: testColor,
      backgroundColor: testColor,
      statusBarColor: testColor,
      primaryTextColor: testColor,
      secondaryTextColor: testColor,
      primaryButtonBackgroundColor: testColor,
      buttonCornerRadius: testButtonCornerRadius,
      logo: testAssetImage,
      androidNotificationIcon: testAndroidNotificationIcon
    );
    expect(branding?.themeColor, testColor);
    expect(branding?.backgroundColor, testColor);
    expect(branding?.statusBarColor, testColor);
    expect(branding?.primaryTextColor, testColor);
    expect(branding?.secondaryTextColor, testColor);
    expect(branding?.primaryButtonBackgroundColor, testColor);
    expect(branding?.buttonCornerRadius, testButtonCornerRadius);
    expect(branding?.logo, testAssetImage);
    expect(branding?.androidNotificationIcon, testAndroidNotificationIcon);
  });

  test("Test Branding as map created correctly.", () async {
    int testButtonCornerRadius = 5;
    branding = Branding(buttonCornerRadius: testButtonCornerRadius);
    Map? brandingAsMap = branding?.asMap();
    expect(brandingAsMap?['themeColor'], null);
    expect(brandingAsMap?['backgroundColor'], null);
    expect(brandingAsMap?['statusBarColor'], null);
    expect(brandingAsMap?['primaryTextColor'], null);
    expect(brandingAsMap?['secondaryTextColor'], null);
    expect(brandingAsMap?['primaryButtonBackgroundColor'], null);
    expect(brandingAsMap?['buttonCornerRadius'], testButtonCornerRadius);
    expect(brandingAsMap?['logo'], null);
    expect(brandingAsMap?['androidNotificationIcon'], null);
  });

  test("Test Branding as map created correctly with AssetImage.", () async {
    AssetImage? testAssetImage = AssetImage("test-image");
    branding = Branding(logo: testAssetImage);
    Map? brandingAsMap = branding?.asMap();
    expect(brandingAsMap?['logo'], "test-image");
  });
}
