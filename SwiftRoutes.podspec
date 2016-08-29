Pod::Spec.new do |s|
  s.name             = 'SwiftRoutes'
  s.version          = '0.1.3'
  s.summary          = 'Simple routing library writtein in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = SwiftRoutes is a simple routing library. SwiftRoutes fires handler according to NSURL.

  s.homepage         = 'https://github.com/takecian/SwiftRoutes'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'takecian' => 'fujikidev@gmail.com' }
  s.source           = { :git => 'https://github.com/takecian/SwiftRoutes.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/*'
  
  # s.resource_bundles = {
  #   'SwiftRoutes' => ['SwiftRoutes/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
