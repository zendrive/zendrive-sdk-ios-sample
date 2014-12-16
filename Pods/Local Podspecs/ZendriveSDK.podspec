Pod::Spec.new do |s| 
  s.name           = "ZendriveSDK"
  s.version        = "3.0.2"
  s.summary        = "Zendrive iOS SDK"
  s.homepage       = "http://www.zendrive.com"
  s.license        = 'Apache License, Version 2.0'
  s.author         = { "Sumant Hanumante" => "sumant@zendrive.com" }
  s.platform       = :ios, '7.0'
  s.source         = { :git => "https://bitbucket.org/zendrive-root/zendrive_cocoapod.git", :tag => "{s.version}" }
  s.frameworks     = "SystemConfiguration", "CoreLocation", "CoreMotion"
  s.libraries      = "z.1.1.3", "sqlite3"

  s.ios.vendored_frameworks = 'ZendriveSDK.framework'
  s.dependency "AWSiOSSDKv2/S3", ' ~> 2.0.0 '
  s.dependency "AWSiOSSDKv2/SQS", ' ~> 2.0.0 '
  s.dependency "FMDB"
  s.dependency "Reachability", ' ~> 3.1.1 '
  s.requires_arc = true
end
