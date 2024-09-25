import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';

FirebaseAppDistributionPlatform get _platform =>
    FirebaseAppDistributionPlatform.instance;

/// Checks if a new release is available and prompts the user to update
/// if there is one. If user is not signed in as a tester, this method will
/// invite the user to become a tester.
Future<void> updateIfNewReleaseAvailable() {
  return _platform.updateIfNewReleaseAvailable();
}

/// Checks if a new release is available.
Future<bool> isNewReleaseAvailable() {
  return _platform.isNewReleaseAvailable();
}

/// Download the new release.
/// Returns a stream of download progress if available on the platform,
/// else returns -1.
Stream<double> downloadUpdate() {
  return _platform.downloadUpdate();
}

/// Checks if tester is signed in.
Future<bool> isTesterSignedIn() {
  return _platform.isTesterSignedIn();
}

/// Sign in a tester without automatically checking for update.
Future<void> signInTester() {
  return _platform.signInTester();
}
