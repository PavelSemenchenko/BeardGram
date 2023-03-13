# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

target 'BeardGram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '10.4.0'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'Alamofire'
  pod 'Photos'
  

  target 'BeardGramTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BeardGramUITests' do
    # Pods for testing
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end
