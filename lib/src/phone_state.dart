import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:phone_state/src/utils/constants.dart';
import 'package:phone_state/src/utils/phone_state_status.dart';

/// PhoneState is a helper class that is used to be able to call the stream of PhoneState
class PhoneState {
  static const EventChannel _eventChannel =
      EventChannel(Constants.EVENT_CHANNEL);

  /// This method allows you to have a stream of the system phone state change
  static Stream<PhoneStateStatus?> get phoneStateStream {
    return _eventChannel.receiveBroadcastStream().distinct().map(
        (dynamic event) => EnumToString.fromString<PhoneStateStatus>(
            PhoneStateStatus.values, event));
  }
}
