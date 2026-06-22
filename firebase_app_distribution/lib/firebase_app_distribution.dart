import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';

FirebaseAppDistributionPlatform get _platform =>
    FirebaseAppDistributionPlatform.instance;

/// Checks if a new release is available and prompts the user to update
/// if there is one. If user is not signed in as a tester, this method will
/// invite the user to become a tester.
Future<void> updateIfNewReleaseAvailable() {
  return _platform.updateIfNewReleaseAvailable();
}

/// Checks for a new release without showing the native update UI.
///
/// Use this to build your own "install available" UI, then call [updateApp]
/// after the user accepts the update.
Future<AppDistributionRelease?> checkForNewRelease() {
  return _platform.checkForNewRelease();
}

/// Starts installing the release previously returned by [checkForNewRelease].
Future<void> updateApp() {
  return _platform.updateApp();
}

/// Emits download progress updates from the native SDK.
///
/// Android emits progress while downloading APK updates. iOS does not expose
/// native download progress because installation is handed off to the system.
Stream<AppDistributionDownloadProgress> get downloadProgress {
  return _platform.downloadProgress;
}

/// Checks if a new release is available.
Future<bool> isNewReleaseAvailable() {
  return _platform.isNewReleaseAvailable();
}

/// Checks if tester is signed in.
Future<bool> isTesterSignedIn() {
  return _platform.isTesterSignedIn();
}

/// Sign in a tester without automatically checking for update.
Future<void> signInTester() {
  return _platform.signInTester();
}

/// Sign out a tester without automatically checking for update.
Future<void> signOutTester() {
  return _platform.signOutTester();
}
