platform :ios, "8.0"

use_frameworks!

target 'Akane' do
  podspec

  target 'AkaneTests' do
    inherit! :search_paths

    pod "Quick"
    pod "Nimble"
  end
end

target 'AkaneBond' do
  podspec

  target 'AkaneBondTests' do
    inherit! :search_paths

    pod "Quick"
    pod "Nimble"
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
