package dev.fluttercommunity.firebase_app_distribution

import android.content.Context
import androidx.annotation.NonNull
import com.google.firebase.appdistribution.FirebaseAppDistribution

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FirebaseAppDistributionPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var progressChannel: EventChannel
    private var context: Context? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "firebase_app_distribution_android")
        channel.setMethodCallHandler(this)
        progressChannel = EventChannel(flutterPluginBinding.binaryMessenger, "firebase_app_distribution_android/download_progress")
        progressChannel.setStreamHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val firebaseAppDistribution = FirebaseAppDistribution.getInstance()
        when(call.method) {
            "updateIfNewReleaseAvailable" -> {
                firebaseAppDistribution.updateIfNewReleaseAvailable()
                    .addOnProgressListener { progress ->
                        emitProgress(progress.apkBytesDownloaded, progress.apkFileTotalBytes, progress.updateStatus.name)
                    }
                    .addOnSuccessListener {
                        result.success(null)
                    }
                    .addOnFailureListener {
                        result.error("UPDATE_FAILED", "Can not update app", "updateIfNewReleaseAvailable() failed with $it")
                    }
            }
            "checkForNewRelease" -> {
                firebaseAppDistribution.checkForNewRelease().addOnSuccessListener { release ->
                    if (release == null) {
                        result.success(null)
                    } else {
                        result.success(mapOf(
                            "displayVersion" to release.displayVersion,
                            "versionCode" to release.versionCode,
                            "releaseNotes" to release.releaseNotes,
                            "binaryType" to release.binaryType.name
                        ))
                    }
                }.addOnFailureListener {
                    result.error("CHECK_FAILED", "Can not check for new release", "checkForNewRelease() failed with $it")
                }
            }
            "updateApp" -> {
                firebaseAppDistribution.updateApp()
                    .addOnProgressListener { progress ->
                        emitProgress(progress.apkBytesDownloaded, progress.apkFileTotalBytes, progress.updateStatus.name)
                    }
                    .addOnSuccessListener {
                        result.success(null)
                    }
                    .addOnFailureListener {
                        result.error("UPDATE_FAILED", "Can not update app", "updateApp() failed with $it")
                    }
            }
            "isNewReleaseAvailable" -> {
                firebaseAppDistribution.checkForNewRelease().addOnSuccessListener { release ->
                    result.success(release != null)
                }.addOnFailureListener {
                    result.error("CHECK_FAILED", "Can not check for new release", "checkForNewRelease() failed with $it")
                }
            }
            "isTesterSignedIn" -> {
                result.success(firebaseAppDistribution.isTesterSignedIn)
            }
            "signInTester" -> {
                firebaseAppDistribution.signInTester().addOnSuccessListener {
                    result.success(true)
                }.addOnFailureListener {
                    result.error("SIGN_IN_TESTER_FAILED", "Can not sign in tester", "signInTester() failed with $it")
                }
            }
            "signOutTester" -> {
                firebaseAppDistribution.signOutTester()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        progressChannel.setStreamHandler(null)
        eventSink = null
        context = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun emitProgress(apkBytesDownloaded: Long, apkFileTotalBytes: Long, updateStatus: String) {
        eventSink?.success(mapOf(
            "apkBytesDownloaded" to apkBytesDownloaded,
            "apkFileTotalBytes" to apkFileTotalBytes,
            "updateStatus" to updateStatus
        ))
    }
}
