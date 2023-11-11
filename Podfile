# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PaperTrader' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PaperTrader

pod 'FirebaseAnalytics'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'Firebase/Crashlytics'
pod 'GoogleSignIn'
pod 'Kingfisher', '~> 7.6.2'
pod 'Firebase/Storage'
pod 'FirebaseRemoteConfig'

  target 'PaperTraderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PaperTraderUITests' do
    # Pods for testing
  end

end

post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          end
      end
  end
