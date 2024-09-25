import 'package:firebase_app_distribution_platform_interface/src/method_channel_firebase_app_distribution.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of firebase_app_distribution must
/// implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `FirebaseAppDistribution`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added
/// [FirebaseAppDistributionPlatform] methods.
abstract class FirebaseAppDistributionPlatform extends PlatformInterface {
  /// Constructs a FirebaseAppDistributionPlatform.
  FirebaseAppDistributionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FirebaseAppDistributionPlatform _instance =
      MethodChannelFirebaseAppDistribution();

  /// The default instance of [FirebaseAppDistributionPlatform] to use.
  ///
  /// Defaults to [MethodChannelFirebaseAppDistribution].
  static FirebaseAppDistributionPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FirebaseAppDistributionPlatform] when they register
  /// themselves.
  static set instance(FirebaseAppDistributionPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Check if a new release is available and prompts the user to update
  /// if there is one.
  Future<void> updateIfNewReleaseAvailable();

  /// Checks if a new release is available.
  Future<bool> isNewReleaseAvailable();

  /// Checks if tester is signed in.
  Future<bool> isTesterSignedIn();

  /// Sign in a tester without automatically checking for update.
  Future<void> signInTester();

  /// Download the new release.
  /// Returns a stream of download progress if available on the platform,
  /// else returns -1.
  Stream<double> downloadUpdate();
}
