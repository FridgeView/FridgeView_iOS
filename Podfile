# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'FridgeView' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FridgeView

	pod 'ParseLiveQuery'
	pod 'Parse'
    pod 'ParseUI'
	pod 'Bolts'
    pod 'Alamofire'
    pod 'Charts'
    pod 'SVProgressHUD'
    pod 'QRCode'

  target 'FridgeViewTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FridgeViewUITests' do
    inherit! :search_paths
    # Pods for testing
  end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

end
