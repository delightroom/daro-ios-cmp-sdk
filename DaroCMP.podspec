Pod::Spec.new do |spec|
  spec.name         = 'DaroCMP'
  spec.version = '0.0.1'
  spec.summary      = 'DaroCMP - Consent Management Platform SDK for iOS'
  spec.description  = <<-DESC
    DaroCMP
  DESC
  
  spec.homepage     = 'https://delightroom.com'
  spec.license      = { :type => 'Custom' }
  spec.author       = { 'Daro Team' => 'finn@delightroom.com' }
  spec.source       = { :http => "https://github.com/delightroom/daro-ios-cmp-sdk/releases/download/#{spec.version}/DaroCMP.xcframework.zip" }
  spec.swift_version = '5.7'
  spec.ios.deployment_target = '13.0'
  
  spec.resource_bundles = {
    'DaroCMPResources' => ['DaroCMP.xcframework/ios-arm64/DaroCMP.framework/PrivacyInfo.xcprivacy']
  }

  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.vendored_frameworks = 'DaroCMP.xcframework'
  
  # Dependencies
  spec.dependency 'Didomi-XCFramework', '~> 2.28.0'
  
end