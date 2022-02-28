<div align="center">
    <img src="https://raw.githubusercontent.com/andreamainella98/phone_state/master/images/icon.png">
</div>

## DESCRIPTION

This plugin allows you to know quickly and easily if your Android or iOS device is receiving a call and to know the status of the call.

- Native Android: [TelephonyManager](https://developer.android.com/reference/android/telephony/TelephonyManager)
- Native iOS: [CallKit](https://developer.apple.com/documentation/callkit)

## PAY ATTENTION

- In the iOS simulator doesn't work

## HOW TO INSTALL
#### Flutter
```yaml
dependencies:
  flutter:
    sdk: flutter
  phone_state: ^1.0.0
```
#### Android: Added permission on manifest
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

## HOW TO USE

### Get stream phone state status

```dart
StreamBuilder<PhoneStateStatus?>(
  initialData: PhoneStateStatus.NOTHING,
  stream: PhoneState.phoneStateStream,
  ...
```

## SCREENSHOT

<img src="https://raw.githubusercontent.com/andreamainella98/phone_state/master/images/example.gif" width=300/>

Write me in the [GitHub](https://github.com/andreamainella98/phone_state/issues) issues the new features you need and, if they are approved of course, I will implement them as soon as I can.

