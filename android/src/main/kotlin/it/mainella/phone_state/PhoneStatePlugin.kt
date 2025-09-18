package it.mainella.phone_state


import io.flutter.embedding.engine.plugins.FlutterPlugin
import it.mainella.phone_state.handler.FlutterHandler

/** PhoneStatePlugin */
class PhoneStatePlugin : FlutterPlugin {
    private lateinit var flutterHandler: FlutterHandler

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterHandler = FlutterHandler(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterHandler.dispose()
    }
}
