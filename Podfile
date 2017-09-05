source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end

target ‘Cinema’ do

	pod 'Alamofire', '~> 4.4'
    pod 'SwiftyJSON'
    pod 'DGActivityIndicatorView'

end
