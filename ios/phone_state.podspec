#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint phone_state.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'phone_state'
  s.version          = '1.0.4'
  s.summary          = 'Plugin used to obtain the status of an incoming call in Android and iOS'
  s.description      = <<-DESC
Plugin used to obtain the status of an incoming call in Android and iOS
                       DESC
  s.homepage         = 'https://github.com/andreamainella98/phone_state'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Andrea Mainella' => 'andrea.mainella98@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
