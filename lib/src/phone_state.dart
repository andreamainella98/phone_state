import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:phone_state/src/utils/constants.dart';
import 'package:phone_state/src/utils/phone_state_status.dart';

/// This class is used to store the current phone state
///
/// To listen to the phone state change, use the [stream] getter
class PhoneState {
  /// The current phone state
  PhoneStateStatus status;

  /// The number of the caller. NOT WORKING ON IOS
  String? number;

  PhoneState._({required this.status, this.number});

  /// This method allows you to create a [PhoneState] object with the status [PhoneStateStatus.NOTHING]
  ///
  /// Use for initializing your [PhoneState] object
  factory PhoneState.nothing() => PhoneState._(status: PhoneStateStatus.NOTHING);

  static const EventChannel _eventChannel = EventChannel(Constants.EVENT_CHANNEL);

  /// This variable allows you to have a stream of the system phone state change
  static final Stream<PhoneState> stream =
      _eventChannel.receiveBroadcastStream().distinct().map((dynamic event) => PhoneState._(
            status: PhoneStateStatus.values.firstWhereOrNull(
                  (element) => element.name == event['status'] as String,
                ) ??
                PhoneStateStatus.NOTHING,
            number: event['phoneNumber'],
          ));
}
