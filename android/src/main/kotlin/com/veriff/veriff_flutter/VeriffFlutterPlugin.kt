package com.veriff.veriff_flutter

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import com.veriff.Configuration
import com.veriff.Result as VeriffResult
import com.veriff.Result.Error.*
import com.veriff.Sdk
import com.veriff.veriff_flutter.helpers.image.AssetLookup
import com.veriff.veriff_flutter.helpers.image.FlutterAssetLookup
import com.veriff.veriff_flutter.helpers.toFlutterConfig
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

private const val REQUEST_CODE = 2001

private const val FLUTTER_CHANNEL = "com.veriff.flutter"

private const val COMMAND_GET_PLATFORM_VERSION = "getPlatformVersion"
private const val COMMAND_START_VERIFF = "veriffStart"

private const val CHANNEL_NAME = "veriff_flutter"

private const val STATUS_DONE = 1
private const val STATUS_CANCELLED = 0
private const val STATUS_ERROR = -1

private const val RESULT_KEY_STATUS = "status"
private const val RESULT_KEY_ERROR = "error"

/**
 * VeriffFlutterPlugin
 *
 * set the build variant in AS to `dev` to remove unresolved references while editing
 *
 * */


class VeriffFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.ActivityResultListener {
  /**
   *  The MethodChannel that will the communication between Flutter and native Android
   *
   *  This local reference serves to register the plugin with the Flutter Engine and unregister it
   *  when the Flutter Engine is detached from the Activity
   */
  private lateinit var channel: MethodChannel
  private var boundActivity: Activity? = null

  private var result: Result? = null

  private var assetLookup: AssetLookup

  //empty constructor for post-Flutter-1.12 Android projects
  constructor() {
    assetLookup = FlutterAssetLookup(FlutterInjector.instance().flutterLoader())
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, FLUTTER_CHANNEL)
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    boundActivity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    boundActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    boundActivity = null
  }

  override fun onDetachedFromActivity() {
    boundActivity = null
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("onMethodCall method", call.method)
    Log.d("onMethodCall arguments", call.arguments?.toString() ?: "")
    when (call.method) {
      COMMAND_GET_PLATFORM_VERSION -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      COMMAND_START_VERIFF -> {
        this.result = result
        boundActivity?.let {
          if (call.arguments != null && call.arguments is Map<*, *>) {
            val flutterConfiguration =
              (call.arguments as Map<String, Any>).toFlutterConfig(
                it.applicationContext,
                assetLookup
              )
            if (flutterConfiguration != null) {
              val configBuilder = Configuration.Builder()
              if (flutterConfiguration.branding != null) {
                configBuilder.branding(flutterConfiguration.branding)
              }
              if (flutterConfiguration.useCustomIntroScreen != null) {
                configBuilder.customIntroScreen(flutterConfiguration.useCustomIntroScreen)
              }
              if (flutterConfiguration.languageLocale != null) {
                configBuilder.locale(flutterConfiguration.languageLocale)
              }
              val veriffConfig = configBuilder.build()
              val intent = Sdk.createLaunchIntent(
                it,
                flutterConfiguration.sessionUrl,
                veriffConfig
              )
              it.startActivityForResult(intent, REQUEST_CODE)
            } else {
              throw IllegalArgumentException("Invalid arguments passed to start")
            }
          } else {
            throw IllegalArgumentException("Invalid arguments passed to start")
          }

        } ?: throw IllegalStateException("Plugin is not bound to any activity yet!")
      }
      else -> result.notImplemented()
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    Log.d("onActivityResult", "$requestCode $resultCode ${data.toString()}")
    if (requestCode == REQUEST_CODE) {
      VeriffResult.fromResultIntent(data)?.let {
        when (it.status!!) {
          VeriffResult.Status.CANCELED -> this.result?.success(
            mapOf(
              RESULT_KEY_STATUS to STATUS_CANCELLED,
              RESULT_KEY_ERROR to it.error?.toFlutterError()
            )
          )
          VeriffResult.Status.ERROR -> this.result?.success(
            mapOf(
              RESULT_KEY_STATUS to STATUS_ERROR,
              RESULT_KEY_ERROR to it.error?.toFlutterError()
            )
          )
          VeriffResult.Status.DONE -> this.result?.success(
            mapOf(
              RESULT_KEY_STATUS to STATUS_DONE,
              RESULT_KEY_ERROR to null
            )
          )
        }
      }
    }
    return true
  }
}


fun VeriffResult.Error.toFlutterError(): String {
  val map = mapOf(
    UNABLE_TO_START_CAMERA to "cameraUnavailable",
    UNABLE_TO_ACCESS_CAMERA to "cameraUnavailable",
    MIC_UNAVAILABLE to "microphoneUnavailable",
    UNABLE_TO_RECORD_AUDIO to "microphoneUnavailable",
    UNSUPPORTED_SDK_VERSION to "deprecatedSDKVersion",
    NFC_DISABLED to "nfcError",
    DEVICE_HAS_NO_NFC to "nfcError",
    SESSION_ERROR to "sessionError",
    NETWORK_ERROR to "networkError",
    SETUP_ERROR to "setupError",
    UNKNOWN_ERROR to "unknown"
  )

  return map[this] ?: throw java.lang.IllegalArgumentException("Invalid error")
}
