import Flutter
import UIKit
import FirebaseAppDistribution

public class FirebaseAppDistributionPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var latestDownloadURL: URL?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "firebase_app_distribution_ios", binaryMessenger: registrar.messenger())
    let progressChannel = FlutterEventChannel(name: "firebase_app_distribution_ios/download_progress", binaryMessenger: registrar.messenger())
    let instance = FirebaseAppDistributionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    progressChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
        case "updateIfNewReleaseAvailable":
          AppDistribution.appDistribution().checkForUpdate(completion: { release, error in
            if error != nil {
                // Handle error
                result(FlutterError(code: "CHECK_FAILED", message: "Can not check for new release", details: error?.localizedDescription))
                return
            }

            guard let release = release else {
              result(nil)
              return
            }

            self.latestDownloadURL = release.downloadURL
            let title = "New Version Available"
            let message = "Version \(release.displayVersion)(\(release.buildVersion)) is available."
            let uialert = UIAlertController(title: title,message: message, preferredStyle: .alert)

            uialert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
              _ in
              UIApplication.shared.open(release.downloadURL)
            })
            uialert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
              _ in
            })

            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.present(uialert, animated: true, completion: nil)
            }
            result(nil)
          })

      case "checkForNewRelease":
          AppDistribution.appDistribution().checkForUpdate(completion: { release, error in
              if error != nil {
                  result(FlutterError(code: "CHECK_FAILED", message: "Can not check for new release", details: error?.localizedDescription))
                  return
              }

              guard let release = release else {
                  self.latestDownloadURL = nil
                  result(nil)
                  return
              }

              self.latestDownloadURL = release.downloadURL
              result([
                  "displayVersion": release.displayVersion,
                  "buildVersion": release.buildVersion,
                  "downloadUrl": release.downloadURL.absoluteString,
              ])
          })

      case "updateApp":
          guard let downloadURL = latestDownloadURL else {
              result(FlutterError(code: "UPDATE_NOT_AVAILABLE", message: "No checked release is available to install", details: nil))
              return
          }

          UIApplication.shared.open(downloadURL)
          result(nil)

      case "isNewReleaseAvailable":
          if (!AppDistribution.appDistribution().isTesterSignedIn) {
              result(false)
              return
          }

          AppDistribution.appDistribution().checkForUpdate(completion: { release, error in
              if error != nil {
                  // Handle error
                  result(FlutterError(code: "CHECK_FAILED", message: "Can not check for new release", details: error?.localizedDescription))
                  return
              }

              guard let release = release else {
                result(false)
                return
              }

              result(true)
          })

      case "isTesterSignedIn":
          result(AppDistribution.appDistribution().isTesterSignedIn)

      case "signInTester":
          AppDistribution.appDistribution().signInTester(completion: {error in
              if error != nil {
                  // Handle error
                  result(FlutterError(code: "SIGN_IN_TESTER_FAILED", message: "Can not sign in tester", details: error?.localizedDescription))
                  return
              }

              result(nil)
          })

      case "signOutTester":
          AppDistribution.appDistribution().signOutTester()
          result(nil)

      default:
          result(nil)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    return nil
  }
}
