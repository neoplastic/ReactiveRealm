#
# Be sure to run `pod lib lint ReactiveRealm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ReactiveRealm"
  s.version          = "0.1.2"
  s.summary          = "Realm + RxSwift = A Good Time"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        Realm is great and all but making it conform to Observables brings a whole new dimension to your UI.
                       DESC


  s.homepage         = "https://github.com/neoplastic/ReactiveRealm"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "David Wong" => "neoplastic@gmail.com" }
  s.source           = { :git => "https://github.com/neoplastic/ReactiveRealm.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/danvari'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RealmSwift', '~> 1.0.0'
  s.dependency 'RxSwift', '~> 2.5.0'
end
