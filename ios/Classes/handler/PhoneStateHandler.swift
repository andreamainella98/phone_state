//
//  PhoneStateHandler.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Foundation
import CallKit
import Flutter

@available(iOS 10.0, *)
class PhoneStateHandler: NSObject, FlutterStreamHandler, CXCallObserverDelegate {
    
    private var _eventSink: FlutterEventSink?
    private var callObserver = CXCallObserver()
    private var callStartTime: Date?
    private var durationTimer: Timer?
    private var callDuration: Int = 0

    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
    }

    private func getCallState(from call: CXCall) -> PhoneStateStatus {
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            return .CALL_INCOMING
        } else if (call.isOutgoing == false && call.hasConnected == true && call.hasEnded == false)
                    || (call.hasConnected == true && call.hasEnded == false && call.isOnHold == false) {
            return .CALL_STARTED
        } else if call.isOutgoing == false && call.hasEnded == true {
            return .CALL_ENDED
        } else {
            return .NOTHING
        }
    }

    private func startDurationTimer() {
        callStartTime = Date()
        callDuration = 0
        durationTimer?.invalidate()
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let startTime = self.callStartTime {
                self.callDuration = Int(Date().timeIntervalSince(startTime))
                self.sendCallState(.CALL_STARTED)
            }
        }
    }

    private func stopDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
        callStartTime = nil
    }

    private func resetCallDuration() {
        stopDurationTimer()
        callDuration = 0
    }

    private func sendCallState(_ status: PhoneStateStatus) {
        if let eventSink = _eventSink {
            eventSink([
                "status": status.rawValue,
                "phoneNumber": nil, // cannot get phone number on iOS
                "callDuration": callDuration
            ])
        }
    }

    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        let status = getCallState(from: call)

        switch status {
        case .CALL_INCOMING:
            resetCallDuration()
        case .CALL_STARTED:
            if callStartTime == nil {
                startDurationTimer()
            }
        case .CALL_ENDED:
            stopDurationTimer()
        default:
            break
        }

        sendCallState(status)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events

        var initialStatus = PhoneStateStatus.NOTHING

        for call in callObserver.calls {
            let callStatus = getCallState(from: call)
            if callStatus != .NOTHING {
                initialStatus = callStatus
                if callStatus == .CALL_INCOMING {
                    resetCallDuration()
                } else if callStatus == .CALL_STARTED && callStartTime == nil {
                    startDurationTimer()
                }
                break
            }
        }

        sendCallState(initialStatus)

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopDurationTimer()
        _eventSink = nil
        return nil
    }

    deinit {
        stopDurationTimer()
    }
}