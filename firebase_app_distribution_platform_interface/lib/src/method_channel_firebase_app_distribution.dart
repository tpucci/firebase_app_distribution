import 'package:firebase_app_distribution_platform_interface/firebase_app_distribution_platform_interface.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

/// An implementation of [FirebaseAppDistributionPlatform] that uses method channels.
class MethodChannelFirebaseAppDistribution
    extends FirebaseAppDistributionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('firebase_app_distribution');

  @override
  Future<void> updateIfNewReleaseAvailable() {
    return methodChannel.invokeMethod<void>('updateIfNewReleaseAvailable');
  }

  @override
  Future<bool> isNewReleaseAvailable() {
    return methodChannel
        .invokeMethod<bool>('isNewReleaseAvailable')
        .then((res) => res ?? false);
  }
}
