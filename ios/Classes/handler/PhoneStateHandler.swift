import Foundation
import CallKit
import Flutter

@available(iOS 10.0, *)
class PhoneStateHandler: NSObject, FlutterStreamHandler, CXCallObserverDelegate {
    
    private var _eventSink: FlutterEventSink?
    private var callObserver = CXCallObserver()
    
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
    
    private func sendCallState(_ status: PhoneStateStatus) {
        if let eventSink = _eventSink {
            eventSink([
                "status": status.rawValue,
                "phoneNumber": nil // cannot get phone number on iOS
            ])
        }
    }
    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        let status = getCallState(from: call)
        sendCallState(status)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        
        var initialStatus = PhoneStateStatus.NOTHING
        
        for call in callObserver.calls {
            let callStatus = getCallState(from: call)
            if callStatus != .NOTHING {
                initialStatus = callStatus
                break
            }
        }
        
        sendCallState(initialStatus)
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
}
