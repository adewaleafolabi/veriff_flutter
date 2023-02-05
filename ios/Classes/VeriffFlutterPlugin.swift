import Flutter
import UIKit
import Veriff

public class VeriffFlutterPlugin: NSObject, FlutterPlugin {

    var veriff: VeriffSdk?
    var delegate: VeriffSdkDelegate?
    var registrar: FlutterPluginRegistrar?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.veriff.flutter", binaryMessenger: registrar.messenger())
        let instance = VeriffFlutterPlugin()
        instance.veriff = VeriffSdk.shared
        instance.veriff?.implementationType = .flutter
        instance.registrar = registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "veriffStart" {
            guard let arguments = call.arguments as? [String: Any],
                  let sessionUrl = arguments["sessionUrl"] as? String else {
                print("No sessionUrl is passed.")
                return
            }
            var branding: VeriffSdk.Branding?
            if let brandingDict = arguments["branding"] as? [String: Any] {
                // let color = (brandingDict["themeColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // var logo: UIImage?
                // if let logoAssetKey = brandingDict["logo"] as? String {
                //     logo = loadLocalAsset(assetKey: logoAssetKey)
                // }
                // branding = VeriffSdk.Branding(themeColor: color, logo: logo)
                // branding?.backgroundColor = (brandingDict["backgroundColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // branding?.statusBarColor = (brandingDict["statusBarColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // branding?.primaryTextColor = (brandingDict["primaryTextColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // branding?.secondaryTextColor = (brandingDict["secondaryTextColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // branding?.primaryButtonBackgroundColor = (brandingDict["primaryButtonBackgroundColor"] as? String).map {
                //     VeriffFlutterPlugin.parseColor(hexcolor: $0)
                // }
                // branding?.buttonCornerRadius = (brandingDict["buttonCornerRadius"] as? Double).map { CGFloat($0) }
            }
            var languageLocale: Locale?
            if let localeIdentifier = arguments["languageLocale"] as? String {
                languageLocale = Locale(identifier: localeIdentifier)
            }
            let configuration = VeriffSdk.Configuration(branding: branding, languageLocale: languageLocale)
            if let useCustomIntro = arguments["useCustomIntroScreen"] as? Bool {
                configuration.customIntroScreen = useCustomIntro
            }
            DispatchQueue.main.async {
                self.delegate = VeriffSdkDelegate(flutterResult: result)  // keeping a strong reference to a delegate
                self.veriff?.delegate = self.delegate
                self.veriff?.startAuthentication(sessionUrl: sessionUrl, configuration: configuration)
            }
        }
    }

    private func loadLocalAsset(assetKey: String) -> UIImage? {
        let key = registrar?.lookupKey(forAsset: assetKey)
        let path = Bundle.main.path(forResource: key, ofType: nil)
        guard path != nil else {
            print("Veriff plugin can't locate the image path for given key: \(key ?? "nil")")
            return nil
        }
        return UIImage(contentsOfFile: path!)

    }

    private static func parseColor(hexcolor: String) -> UIColor {
        var hexcolor: String = hexcolor
        if (hexcolor.starts(with: "#")) {
            hexcolor = String(hexcolor.dropFirst())
        }
        var color: UInt64 = 0
        Scanner(string: hexcolor).scanHexInt64(&color)
        var a: CGFloat = 1.0
        if (hexcolor.count > 7) {
            // #rrggbbaa
            a = CGFloat(color & 0xff) / 255.0
            color = color >> 8
        }
        let r = CGFloat((color >> 16) & 0xff) / 255.0
        let g = CGFloat((color >> 8) & 0xff) / 255.0
        let b = CGFloat(color & 0xff) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class VeriffSdkDelegate: Veriff.VeriffSdkDelegate {
    let flutterResult: FlutterResult

    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
    }

    public func sessionDidEndWithResult(_ result: VeriffSdk.Result) {
        let (status, statusString) = resultToFlutter(result: result)
        let resultDict: [String: Any] = ["status": status, "error": statusString]
        flutterResult(resultDict)
    }

    private func resultToFlutter(result: VeriffSdk.Result) -> (Int, String) {
        switch result.status {
        case .done:
            return (1, "none")
        case .canceled:
            return (0, "none")
        case .error(let err):
            switch err {
            case .cameraUnavailable:
                return (-1, "cameraUnavailable")
            case .microphoneUnavailable:
                return (-1, "microphoneUnavailable")
            case .networkError,
                 .uploadError:
                return (-1, "networkError")
            case .serverError,
                 .videoFailed,
                 .localError:
                return (-1, "sessionError")
            case .unknown:
                return (-1, "unknown")
            case .deprecatedSDKVersion:
                return (-1, "deprecatedSDKVersion")
            default:
                return (-3, "")
            }
        default:
            return (-3, "")
        }
    }
}
