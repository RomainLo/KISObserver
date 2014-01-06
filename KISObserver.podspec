#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "KISObserver"
  s.version      = "0.1.0"
  s.summary      = "A friendly KVO implementation with blocks and selectors."
  s.license      = 'MIT'
  s.source       = { :git => "https://github.com/RomainLo/KISObserver.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'Classes'
  # s.public_header_files = 'Classes/**/*.h'
end
