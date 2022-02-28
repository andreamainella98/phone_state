//
//  FlutterHandler.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Foundation

@available(iOS 10.0, *)
class FlutterHandler{
    private let phoneStateChannel: FlutterEventChannel
    
    init(binding: FlutterPluginRegistrar) {
        phoneStateChannel = FlutterEventChannel(
            name: Constants.EVENT_CHANNEL,
            binaryMessenger: binding.messenger());
        
        phoneStateChannel.setStreamHandler(PhoneStateHandler())
    }
    
    public func dispose(){
        phoneStateChannel.setStreamHandler(nil)
    }
}
