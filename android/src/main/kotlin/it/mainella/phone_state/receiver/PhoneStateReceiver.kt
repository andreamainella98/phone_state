package it.mainella.phone_state.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import it.mainella.phone_state.utils.PhoneStateStatus

open class PhoneStateReceiver : BroadcastReceiver() {
    var status: PhoneStateStatus = PhoneStateStatus.NOTHING
    var phoneNumber: String? = null
    private var callStartTime: Long = 0
    private var onDurationChanged: ((Long) -> Unit)? = null

    private var _callDuration: Long = 0
    var callDuration: Long
        get() = _callDuration
        private set(value) {
            if (_callDuration != value) {
                _callDuration = value
                onDurationChanged?.invoke(value)
            }
        }

    private fun resetDuration() {
        callStartTime = 0
        callDuration = 0
    }

    fun updateDuration() {
        if (callStartTime > 0) {
            callDuration = (System.currentTimeMillis() - callStartTime) / 1000
        }
    }

    fun instance(context: Context) {
        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        status = when (telephonyManager.callState) {
            TelephonyManager.CALL_STATE_RINGING -> {
                resetDuration()
                PhoneStateStatus.CALL_INCOMING
            }

            TelephonyManager.CALL_STATE_OFFHOOK -> {
                callStartTime = System.currentTimeMillis()
                updateDuration()
                PhoneStateStatus.CALL_STARTED
            }

            TelephonyManager.CALL_STATE_IDLE -> {
                updateDuration()
                callStartTime = 0
                PhoneStateStatus.CALL_ENDED
            }

            else -> PhoneStateStatus.NOTHING
        }
        phoneNumber = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        try {
            status = when (intent?.getStringExtra(TelephonyManager.EXTRA_STATE)) {
                TelephonyManager.EXTRA_STATE_RINGING -> {
                    resetDuration()
                    PhoneStateStatus.CALL_INCOMING
                }

                TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                    callStartTime = System.currentTimeMillis()
                    updateDuration()
                    PhoneStateStatus.CALL_STARTED
                }

                TelephonyManager.EXTRA_STATE_IDLE -> {
                    updateDuration()
                    callStartTime = 0
                    PhoneStateStatus.CALL_ENDED
                }

                else -> PhoneStateStatus.NOTHING
            }

            phoneNumber = intent?.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}