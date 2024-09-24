import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';

FirebaseAppDistributionPlatform get _platform =>
    FirebaseAppDistributionPlatform.instance;

/// Checks if a new release is available and prompts the user to update
/// if there is one.
Future<void> updateIfNewReleaseAvailable() {
  return _platform.updateIfNewReleaseAvailable();
}

/// Checks if a new release is available.
Future<bool> isNewReleaseAvailable() {
  return _platform.isNewReleaseAvailable();
}
