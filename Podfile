platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target 'speedrun' do
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  pod 'KeychainAccess'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'SnapKit'
  target 'speedrunTests' do
    inherit! :search_paths
    pod 'RealmSwift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'KeychainAccess'
    pod 'RxCocoa'
    pod 'RxSwift'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end
