<div align="center">
    <img src="https://raw.githubusercontent.com/andreamainella98/phone_state/master/images/icon.png">
</div>

## DESCRIPTION

This plugin allows you to know quickly and easily if your Android or iOS device is receiving a call and to know the status of the call.

- Native Android: [TelephonyManager](https://developer.android.com/reference/android/telephony/TelephonyManager)
- Native iOS: [CallKit](https://developer.apple.com/documentation/callkit)

## PAY ATTENTION

- In the iOS simulator doesn't work
- The phone number is only obtainable on Android!

## HOW TO INSTALL
#### Flutter
```yaml
dependencies:
  flutter:
    sdk: flutter
  phone_state: 1.0.3
```
#### Android: Added permission on manifest
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.READ_CALL_LOG" />
```
> **Warning**: Adding `READ_CALL_LOG` permission, your app will be removed from the Play Store if you don't have a valid reason to use it. [Read more](https://support.google.com/googleplay/android-developer/answer/9047303?hl=en). But if you don't add it, you will not be able to know caller's number.

## HOW TO USE

### Get stream phone state status

```dart
StreamBuilder<PhoneState>(
  initialData: PhoneState.nothing(),
  stream: PhoneState.stream,
  ...
```

## SCREENSHOT

<img src="https://raw.githubusercontent.com/andreamainella98/phone_state/master/images/example.gif" width=300/>

Write me in the [GitHub](https://github.com/andreamainella98/phone_state/issues) issues the new features you need and, if they are approved of course, I will implement them as soon as I can.

