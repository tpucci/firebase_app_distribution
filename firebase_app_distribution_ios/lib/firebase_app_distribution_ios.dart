import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The iOS implementation of [FirebaseAppDistributionPlatform].
class FirebaseAppDistributionIOS extends FirebaseAppDistributionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('firebase_app_distribution_ios');

  /// Registers this class as the default instance of [FirebaseAppDistributionPlatform]
  static void registerWith() {
    FirebaseAppDistributionPlatform.instance = FirebaseAppDistributionIOS();
  }

  @override
  Future<void> updateIfNewReleaseAvailable() async {
    return methodChannel.invokeMethod<void>('updateIfNewReleaseAvailable');
  }
}
