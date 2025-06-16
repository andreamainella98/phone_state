package it.mainella.phone_state.handler

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import it.mainella.phone_state.receiver.PhoneStateReceiver
import it.mainella.phone_state.utils.Constants
import it.mainella.phone_state.utils.PhoneStateStatus
import java.util.Timer
import java.util.TimerTask

class FlutterHandler(binding: FlutterPlugin.FlutterPluginBinding) {
    private var phoneStateEventChannel: EventChannel = EventChannel(binding.binaryMessenger, Constants.EVENT_CHANNEL)
    private var durationTimer: Timer? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    init {
        phoneStateEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private lateinit var receiver: PhoneStateReceiver

            private fun startDurationUpdates(events: EventChannel.EventSink?) {
                durationTimer?.cancel()
                durationTimer = Timer()
                durationTimer?.schedule(object : TimerTask() {
                    override fun run() {
                        if (receiver.status == PhoneStateStatus.CALL_STARTED) {
                            receiver.updateDuration()
                            mainHandler.post {
                                events?.success(
                                    mapOf(
                                        "status" to receiver.status.name,
                                        "phoneNumber" to receiver.phoneNumber,
                                        "callDuration" to receiver.callDuration.toInt()
                                    )
                                )
                            }
                        }
                    }
                }, 0, 1000)
            }

            private fun stopDurationUpdates() {
                durationTimer?.cancel()
                durationTimer = null
            }

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                receiver = object : PhoneStateReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        super.onReceive(context, intent)
                        if (status == PhoneStateStatus.CALL_STARTED) {
                            startDurationUpdates(events)
                        } else if (status == PhoneStateStatus.CALL_ENDED) {
                            stopDurationUpdates()
                        }
                        events?.success(
                            mapOf(
                                "status" to status.name,
                                "phoneNumber" to phoneNumber,
                                "callDuration" to callDuration.toInt()
                            )
                        )
                    }
                }

                val context = binding.applicationContext
                val hasPhoneStatePermission = ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.READ_PHONE_STATE
                ) == PackageManager.PERMISSION_GRANTED

                val hasCallLogPermission = ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.READ_CALL_LOG
                ) == PackageManager.PERMISSION_GRANTED

                if (hasPhoneStatePermission && hasCallLogPermission) {
                    receiver.instance(context)
                    events?.success(
                        mapOf(
                            "status" to receiver.status.name,
                            "phoneNumber" to receiver.phoneNumber,
                            "callDuration" to receiver.callDuration.toInt()
                        )
                    )
                }

                binding.applicationContext.registerReceiver(
                    receiver,
                    IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
                )
            }

            override fun onCancel(arguments: Any?) {
                stopDurationUpdates()
                binding.applicationContext.unregisterReceiver(receiver)
            }
        })
    }

    fun dispose() {
        durationTimer?.cancel()
        durationTimer = null
        phoneStateEventChannel.setStreamHandler(null)
    }
}