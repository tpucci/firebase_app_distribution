package dev.fluttercommunity.firebase_app_distribution

import android.content.Context
import androidx.annotation.NonNull
import com.google.firebase.appdistribution.FirebaseAppDistribution

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FirebaseAppDistributionPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "firebase_app_distribution_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val firebaseAppDistribution = FirebaseAppDistribution.getInstance()
        when(call.method) {
            "updateIfNewReleaseAvailable" -> {
                firebaseAppDistribution.updateIfNewReleaseAvailable()
                result.success(null)
            }
            "isNewReleaseAvailable" -> {
                firebaseAppDistribution.checkForNewRelease().addOnSuccessListener { release ->
                    result.success(release != null)
                }.addOnFailureListener {
                    result.error("CHECK_FAILED", "Can not check for new release", "checkForNewRelease() failed with $it")
                }
            }
            "downloadUpdate" -> {
                firebaseAppDistribution.updateApp()
                result.success(-1)
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
        context = null
    }
}
