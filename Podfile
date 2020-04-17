# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Quizzler' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Quizzler
  pod 'Alamofire', '= 4.0'
  pod 'SwiftyJSON', '= 4.0'
  pod 'ObjectMapper', '= 3.0'
  pod 'Firebase', '=5.0'
  pod 'Firebase/Auth', '=5.0'
  pod 'Firebase/Database', '=5.0'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore', '=5.0'
  pod 'SVProgressHUD'
  pod 'ChameleonFramework'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end

