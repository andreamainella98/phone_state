#import "PhoneStatePlugin.h"
#if __has_include(<phone_state/phone_state-Swift.h>)
#import <phone_state/phone_state-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "phone_state-Swift.h"
#endif

@implementation PhoneStatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhoneStatePlugin registerWithRegistrar:registrar];
}
@end
