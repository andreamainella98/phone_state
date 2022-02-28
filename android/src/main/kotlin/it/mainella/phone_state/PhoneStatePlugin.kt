package it.mainella.phone_state

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import it.mainella.phone_state.handler.FlutterHandler

class PhoneStatePlugin : FlutterPlugin {
    private lateinit var flutterHandler: FlutterHandler

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        flutterHandler = FlutterHandler(binding)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        flutterHandler.dispose()
    }


}
