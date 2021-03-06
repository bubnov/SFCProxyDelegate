Pod::Spec.new do |s|
  s.name            = "SFCProxyDelegate"
  s.version         = "0.1.0"
  s.summary         = "Proxy delegate, Objective-C"
  s.homepage        = "https://github.com/bubnov/SFCProxyDelegate"
  s.license         = 'MIT'
  s.author          = { "Bubnov Slavik" => "bubnovslavik@gmail.com" }
  s.source          = { :git => "https://github.com/bubnov/SFCProxyDelegate.git", :tag => s.version.to_s }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.source_files    = 'SFCProxyDelegate'
end
