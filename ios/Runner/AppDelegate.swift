import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GSMServices.provideAPIKey("AIzaSyArLwdj4n4U2gZShrEaBLO7mPlzrhSjq1k")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
