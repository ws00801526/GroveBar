#
# Be sure to run `pod lib lint GroveBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GroveBar'
  s.version          = '0.0.1'
  s.summary          = 'A swift version of JDStatusBarNotification.'
  s.description      = <<-DESC
  Highly customizable & feature rich notifications displayed below the status bar. Customizable colors, fonts & animations. Supports notch and no-notch devices, landscape & portrait layouts and Drag-to-Dismiss. Can display a subtitle, an activity indicator, a progress bar & custom views out of the box. iOS 12+. Swift ready!
                       DESC
  s.homepage         = 'https://github.com/ws00801526/GroveBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Fraker.XM' => '3057600441@qq.com' }
  s.source           = { :git => 'https://github.com/ws00801526/GroveBar.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.4'
  s.source_files = 'GroveBar/Classes/**/*'
end
