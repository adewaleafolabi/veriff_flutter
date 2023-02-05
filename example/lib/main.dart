import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _sessionResult = 'Not started';
  String _sessionError = 'None';
  TextEditingController _sessionURLController;
  TextEditingController _localeController;
  bool _isBrandingOn = false;
  bool _useCustomIntro = false;

  @override
  void initState() {
    super.initState();
    _sessionURLController = TextEditingController();
    _localeController = TextEditingController();
    initPlatformState();
  }

  @override
  void dispose() {
    _sessionURLController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Veriff().platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Configuration setupConfiguration() {
    Configuration config = Configuration(_sessionURLController.text);
    AssetImage logo = AssetImage('assets/wsb.png');
    if (_isBrandingOn) {
      Branding branding = Branding(
        themeColor: "#ff00ff",
        backgroundColor: "#f2ff00",
        statusBarColor: "#ff7700",
        primaryTextColor: "#52b35c",
        secondaryTextColor: "#3a593d",
        primaryButtonBackgroundColor: "#ff9800",
        buttonCornerRadius: 5,
        logo: logo,
        androidNotificationIcon: "ic_notification",
      );
      config.branding = branding;
    }
    if (_localeController.text.length != 0) {
      config.languageLocale = _localeController.text;
    }
    if (_useCustomIntro) {
      config.useCustomIntroScreen = _useCustomIntro;
      print('Custom intro set to: $_useCustomIntro');
    }
    return config;
  }

  Future<void> _startVeriffFlow() async {
    if (_sessionURLController.text == null) {
      print("You must enter a session URL!");
      return;
    }
    Veriff veriff = Veriff();
    Configuration config = setupConfiguration();
    try {
      Result result = await veriff.start(config);
      print("================= Result from Veriff SDK ================\n");
      setState(() {
        _sessionResult = result.status.toString();
        _sessionError = result.error.toString();
      });
      switch (result.status) {
        case Status.done:
          print("Session is completed.");
          break;
        case Status.canceled:
          print("Session is canceled by the user.");
          break;
        case Status.error:
          switch (result.error) {
            case Error.cameraUnavailable:
              print("User did not give permission for the camera");
              break;
            case Error.microphoneUnavailable:
              print("User did not give permission for the microphone.");
              break;
            case Error.networkError:
              print("Network error occurred.");
              break;
            case Error.sessionError:
              print("A local error happened before submitting the session.");
              break;
            case Error.deprecatedSDKVersion:
              print(
                  "Version of Veriff SDK used in plugin has been deprecated. Please update to the latest version.");
              break;
            case Error.unknown:
              print("Uknown error occurred.");
              break;
            case Error.nfcError:
              print("Error with NFC");
              break;
            case Error.setupError:
              print("Error with setup");
              break;
            case Error.none:
              print("No error.");
              break;
            default:
              break;
          }
          break;
        default:
          break;
      }
      print("==========================================================\n");
    } on PlatformException {
      //log this
    }
  }

  Future<void> _scanQRCode() async {
    var result = await BarcodeScanner.scan();
    _sessionURLController.text = result.rawContent;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Veriff Flutter example app'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: TextField(
                        controller: _sessionURLController,
                        decoration: InputDecoration(
                          labelText: 'Enter session URL',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _scanQRCode,
                    child: Text("Scan QR code"),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: TextField(
                        controller: _localeController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Locale'),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Customisation',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          value: _isBrandingOn,
                          onChanged: (value) {
                            setState(() {
                              _isBrandingOn = value;
                            });
                          }),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'Custom Intro',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          value: _useCustomIntro,
                          onChanged: (value) {
                            setState(() {
                              _useCustomIntro = value;
                            });
                          }),
                    ],
                  ),
                  SizedBox(width: 20),
                ],
              ),
              Text('Running on: $_platformVersion\n'),
              TextButton(
                  onPressed: _startVeriffFlow, child: Text("Start veriff")),
              Text('Session result: $_sessionResult'),
              Text('Session error: $_sessionError'),
            ],
          ),
        ),
      ),
    );
  }
}
