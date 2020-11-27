# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'App'
target 'App' do
  project 'App.xcodeproj'
  
  pod 'SnapKit'
  
  target 'Home' do
    project 'Modules/Home/Home.xcodeproj'
  end
  
  target 'Shop' do
    project 'Modules/Shop/Shop.xcodeproj'
  end
  
  target 'Sale' do
    project 'Modules/Sale/Sale.xcodeproj'
  end
  
  target 'Goods' do
    project 'Modules/Goods/Goods.xcodeproj'
  end
  
  
  target 'AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AppUITests' do
    # Pods for testing
  end

end
