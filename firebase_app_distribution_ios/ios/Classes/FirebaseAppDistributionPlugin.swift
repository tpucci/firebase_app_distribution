import Flutter
import UIKit
import FirebaseAppDistribution

public class FirebaseAppDistributionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "firebase_app_distribution_ios", binaryMessenger: registrar.messenger())
    let instance = FirebaseAppDistributionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      AppDistribution.appDistribution().checkForUpdate(completion: { release, error in
        if error != nil {
            // Handle error
            return
        }

        guard let release = release else {
          return
        }

        // Customize your alerts here.
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
      })
    result(nil)
  }
}
