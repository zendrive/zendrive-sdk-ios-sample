# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

SDK_VERSION='5.9.0'

target 'ZendriveSDKDemo' do
  pod 'ZendriveSDK', :git => 'https://bitbucket.org/zendrive-root/zendrive_cocoapod.git', :tag => SDK_VERSION
  pod 'MBProgressHUD', '~> 1.1.0'
end

target 'Testing-ZendriveSDKDemo' do
  pod 'ZendriveSDK/Testing', :git => 'https://bitbucket.org/zendrive-root/zendrive_cocoapod.git', :tag => SDK_VERSION
  pod 'MBProgressHUD', '~> 1.1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
    end
  end
end
