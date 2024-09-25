import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The Android implementation of [FirebaseAppDistributionPlatform].
class FirebaseAppDistributionAndroid extends FirebaseAppDistributionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('firebase_app_distribution_android');

  /// Registers this class as the default instance of
  /// [FirebaseAppDistributionPlatform]
  static void registerWith() {
    FirebaseAppDistributionPlatform.instance = FirebaseAppDistributionAndroid();
  }

  @override
  Future<String?> updateIfNewReleaseAvailable() {
    return methodChannel.invokeMethod<String>('updateIfNewReleaseAvailable');
  }

  @override
  Future<bool> isNewReleaseAvailable() {
    return methodChannel
        .invokeMethod<bool>('isNewReleaseAvailable')
        .then((res) => res ?? false);
  }

  @override
  Stream<double> downloadUpdate() {
    return methodChannel
        .invokeMethod<double>('downloadUpdate')
        .asStream()
        .map((res) => res ?? -1);
  }

  @override
  Future<bool> isTesterSignedIn() {
    return methodChannel
        .invokeMethod<bool>('isTesterSignedIn')
        .then((res) => res ?? false);
  }

  @override
  Future<void> signInTester() {
    return methodChannel.invokeMethod<void>('signInTester');
  }
}
