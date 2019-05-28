Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.name = 'Themer'
  s.summary = 'Theme manager provides theming functionality for an entire app and enables to easily toggle the current theme, all at once.'
  s.version = '1.0.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Serge Bouts' => 'sergebouts@gmail.com' }
  s.homepage = 'https://github.com/SergeBouts/Themer'
  s.source = { :git => 'https://github.com/SergeBouts/Themer.git', :tag => '#{s.version}' }
  s.source_files  = 'Sources/Themer/**/*.swift'
  s.swift_version = '4.2'
  s.requires_arc = true
end

