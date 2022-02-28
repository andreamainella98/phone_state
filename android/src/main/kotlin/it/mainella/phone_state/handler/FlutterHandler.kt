package it.mainella.phone_state.handler

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import it.mainella.phone_state.receiver.PhoneStateReceiver
import it.mainella.phone_state.utils.Constants

class FlutterHandler(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    private var phoneStateEventChannel: EventChannel = EventChannel(binding.binaryMessenger, Constants.EVENT_CHANNEL)

    init {
        phoneStateEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private lateinit var receiver: PhoneStateReceiver

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                receiver = object : PhoneStateReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        super.onReceive(context, intent)
                        events?.success(receiver.status.toString())
                    }
                }

                binding.applicationContext.registerReceiver(
                    receiver,
                    IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
                )
            }

            override fun onCancel(arguments: Any?) {
                binding.applicationContext.unregisterReceiver(receiver)
            }
        })
    }

    fun dispose() {
        phoneStateEventChannel.setStreamHandler(null)
    }
}