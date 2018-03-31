Pod::Spec.new do |s|
  s.name             = 'SwiftRoutes'
  s.version          = '1.0.0'
  s.summary          = 'Simple routing library writtein in Swift.'
  s.description      = 'SwiftRoutes is a simple routing library. SwiftRoutes fires handler according to NSURL.'

  s.homepage         = 'https://github.com/takecian/SwiftRoutes'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'takecian' => 'fujikidev@gmail.com' }
  s.source           = { :git => 'https://github.com/takecian/SwiftRoutes.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/*'
end
