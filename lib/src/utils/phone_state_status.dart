/// These are the system phone state profiles
enum PhoneStateStatus {
  /// No phone state detected
  NOTHING,

  /// Incoming call detected (Android & iOS)
  CALL_INCOMING,

  /// Outgoing call detected (⚠️ only available on iOS)
  CALL_OUTGOING,

  /// A call is currently active (Android & iOS)
  CALL_STARTED,

  /// The call has ended (Android & iOS)
  CALL_ENDED,
}
