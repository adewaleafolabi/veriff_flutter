import "branding.dart";

/// Contains configuration options available for Veriff.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
class Configuration {
  /// Session URL to start verification session.
  String sessionUrl;

  /// Optional branding object to configure Veriff SDK UI.
  Branding? branding;

  /// Optional locale identifier to set language
  String? languageLocale;

  /// Boolean to enable/disable custom intro screen.
  /// NB: This boolean alone is not enough to enable the custom
  /// intro screen. Please contact your account manager to enable
  /// it for your integration.
  bool? useCustomIntroScreen;

  /// Creates a [Configuration] object.
  Configuration(this.sessionUrl,
      {this.branding, this.languageLocale, this.useCustomIntroScreen});

  /// Returns the [Branding] object as map.
  Map<String, dynamic> asMap() {
    Map<String, dynamic>? brandingMap;
    if (this.branding != null) brandingMap = this.branding!.asMap();
    return {
      "sessionUrl": this.sessionUrl,
      "languageLocale": this.languageLocale,
      "useCustomIntroScreen": this.useCustomIntroScreen,
      "branding": brandingMap
    };
  }
}
