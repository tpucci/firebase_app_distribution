import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The Android implementation of [FirebaseAppDistributionPlatform].
class FirebaseAppDistributionAndroid extends FirebaseAppDistributionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'firebase_app_distribution_android',
  );

  /// The event channel used to receive download progress updates.
  @visibleForTesting
  final eventChannel = const EventChannel(
    'firebase_app_distribution_android/download_progress',
  );

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
  Future<AppDistributionRelease?> checkForNewRelease() async {
    final release = await methodChannel.invokeMapMethod<Object?, Object?>(
      'checkForNewRelease',
    );
    return release == null ? null : AppDistributionRelease.fromMap(release);
  }

  @override
  Future<void> updateApp() {
    return methodChannel.invokeMethod<void>('updateApp');
  }

  @override
  Stream<AppDistributionDownloadProgress> get downloadProgress {
    return eventChannel.receiveBroadcastStream().map(
      (event) => AppDistributionDownloadProgress.fromMap(
        event! as Map<Object?, Object?>,
      ),
    );
  }

  @override
  Future<bool> isNewReleaseAvailable() {
    return methodChannel
        .invokeMethod<bool>('isNewReleaseAvailable')
        .then((res) => res ?? false);
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

  @override
  Future<void> signOutTester() {
    return methodChannel.invokeMethod<void>('signOutTester');
  }
}
