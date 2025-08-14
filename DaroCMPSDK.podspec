Pod::Spec.new do |spec|
  spec.name         = 'DaroCMPSDK'
  spec.version = '0.0.4'
  spec.summary      = 'DaroCMPSDK - Consent Management Platform SDK for iOS'
  spec.description  = <<-DESC
    DaroCMPSDK - Consent Management Platform SDK for iOS
  DESC
  
  spec.homepage     = 'https://delightroom.com'
  spec.license      = { :type => 'Custom' }
  spec.author       = { 'Daro Team' => 'finn@delightroom.com' }
  spec.source       = { :http => "https://github.com/delightroom/daro-ios-cmp-sdk/releases/download/#{spec.version}/DaroCMPSDK.xcframework.zip" }
  spec.swift_version = '5.7'
  spec.ios.deployment_target = '13.0'
  
  spec.resource_bundles = {
    'DaroCMPResources' => ['DaroCMPSDK.xcframework/ios-arm64/DaroCMPSDK.framework/PrivacyInfo.xcprivacy']
  }

  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.vendored_frameworks = 'DaroCMPSDK.xcframework'
  
  # Dependencies
  spec.dependency 'Didomi-XCFramework', '~> 2.28.0'
  
end