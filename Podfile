# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Chameleon' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'SlideMenuControllerSwift'
  pod 'SJFluidSegmentedControl'
  pod 'iOSDropDown'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end

  # Pods for Chameleon

  target 'ChameleonTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ChameleonUITests' do
    # Pods for testing
  end

end
