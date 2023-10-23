platform :ios, '14.0'

target 'MapPlans' do
   use_frameworks!

  # Pods for MapToDo
  pod 'GooglePlaces', '8.0.0'
  pod 'RealmSwift', '~>10'

end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
