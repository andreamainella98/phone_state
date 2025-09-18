//
//  PhoneStateHandler.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Foundation
import CallKit
import Flutter

@available(iOS 13.0, *)
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
        if !call.isOutgoing && !call.hasConnected && !call.hasEnded {
            return .CALL_INCOMING
        } else if call.isOutgoing && !call.hasConnected && !call.hasEnded {
            return .CALL_OUTGOING
        } else if (call.hasConnected && !call.hasEnded && !call.isOnHold) {
            return .CALL_STARTED
        } else if call.hasEnded {
            return .CALL_ENDED
        } else {
            return .NOTHING
        }
    }
    
    private func startDurationTimer() {
        callStartTime = Date()
        callDuration = 0
        durationTimer?.invalidate()
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self]_ in guard let self = self else { return }
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
            eventSink(["status": status.rawValue,
                       "phoneNumber": nil, // cannot get phone number on iOS
                       "callDuration": callDuration
                      ])
        }
    }
    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        let status = getCallState(from: call)
        
        switch status {
        case.CALL_INCOMING: // Incoming call ringing — reset duration timer resetCallDuration()
        case.CALL_OUTGOING: // Outgoing dialing — reset timer (will start once connected) resetCallDuration()
        case.CALL_STARTED: // Call connected (incoming answered or outgoing connected)
            if callStartTime == nil {
                startDurationTimer()
            }
        case.CALL_ENDED: // Call finished stopDurationTimer()
        default: break
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
                
                switch callStatus {
                case.CALL_INCOMING, .CALL_OUTGOING: // Reset duration timer for new incoming/outgoing calls resetCallDuration()
                    
                case.CALL_STARTED: // Start timer if a call is already in progress
                    if callStartTime == nil {
                        startDurationTimer()
                    }
                default:
                    break
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
