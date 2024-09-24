Pod::Spec.new do |s|
  s.name             = 'firebase_app_distribution_ios'
  s.version          = '0.0.1'
  s.summary          = 'An iOS implementation of the firebase_app_distribution plugin.'
  s.description      = <<-DESC
  An iOS implementation of the firebase_app_distribution plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.dependency 'firebase_core'
  s.dependency 'FirebaseAppDistribution', '~> 11.2.0-beta'
  s.static_framework = true

  s.platform = :ios, '9.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
