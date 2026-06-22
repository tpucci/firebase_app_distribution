import 'package:firebase_app_distribution_platform_interface/src/method_channel_firebase_app_distribution.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Information about a Firebase App Distribution release available to install.
class AppDistributionRelease {
  /// Creates release information.
  const AppDistributionRelease({
    required this.displayVersion,
    this.buildVersion,
    this.versionCode,
    this.releaseNotes,
    this.binaryType,
    this.downloadUrl,
  });

  /// Creates release information from platform channel data.
  factory AppDistributionRelease.fromMap(Map<Object?, Object?> map) {
    return AppDistributionRelease(
      displayVersion: map['displayVersion']! as String,
      buildVersion: map['buildVersion'] as String?,
      versionCode: map['versionCode'] as int?,
      releaseNotes: map['releaseNotes'] as String?,
      binaryType: map['binaryType'] as String?,
      downloadUrl: map['downloadUrl'] as String?,
    );
  }

  /// Short user-facing version string.
  final String displayVersion;

  /// Platform build version, when available.
  final String? buildVersion;

  /// Android version code, when available.
  final int? versionCode;

  /// Release notes for this build, when available.
  final String? releaseNotes;

  /// Binary type, such as APK or AAB, when available.
  final String? binaryType;

  /// iOS download URL, when available.
  final String? downloadUrl;
}

/// Progress for an App Distribution update download.
class AppDistributionDownloadProgress {
  /// Creates download progress information.
  const AppDistributionDownloadProgress({
    required this.apkBytesDownloaded,
    required this.apkFileTotalBytes,
    required this.updateStatus,
  });

  /// Creates download progress information from platform channel data.
  factory AppDistributionDownloadProgress.fromMap(Map<Object?, Object?> map) {
    return AppDistributionDownloadProgress(
      apkBytesDownloaded: map['apkBytesDownloaded']! as int,
      apkFileTotalBytes: map['apkFileTotalBytes']! as int,
      updateStatus: map['updateStatus']! as String,
    );
  }

  /// Number of APK bytes downloaded, or -1 when unavailable.
  final int apkBytesDownloaded;

  /// Total APK size in bytes, or -1 when unavailable.
  final int apkFileTotalBytes;

  /// Native Firebase update status name.
  final String updateStatus;
}

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

  /// Checks for a new release and returns its metadata without showing the
  /// native update UI.
  Future<AppDistributionRelease?> checkForNewRelease() {
    throw UnimplementedError('checkForNewRelease() has not been implemented.');
  }

  /// Starts installing the release previously returned by [checkForNewRelease].
  Future<void> updateApp() {
    throw UnimplementedError('updateApp() has not been implemented.');
  }

  /// Emits native download progress updates.
  Stream<AppDistributionDownloadProgress> get downloadProgress {
    throw UnimplementedError('downloadProgress has not been implemented.');
  }

  /// Checks if a new release is available.
  Future<bool> isNewReleaseAvailable();

  /// Checks if tester is signed in.
  Future<bool> isTesterSignedIn();

  /// Sign in a tester without automatically checking for update.
  Future<void> signInTester();

  /// Sign in a tester without automatically checking for update.
  Future<void> signOutTester();
}
