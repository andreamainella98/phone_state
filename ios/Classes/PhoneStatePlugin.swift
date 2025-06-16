//
//  PhoneStatePlugin.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Flutter
import UIKit

@available(iOS 10.0, *)
public class PhoneStatePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let _: FlutterHandler = FlutterHandler(binding: registrar)
    }
}
