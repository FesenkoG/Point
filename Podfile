# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Point' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'PhoneNumberKit', '~> 2.1'
  pod 'Starscream', '~> 3.0.2'
  pod 'KeychainSwift', '~> 13.0'
  pod 'AlamofireImage', '~> 3.5'
  pod 'Alamofire'
  pod 'SkeletonView'
  
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings[‘PROVISIONING_PROFILE_SPECIFIER’] = ''
    end
end
