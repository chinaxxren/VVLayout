
Pod::Spec.new do |spec|
  spec.name         = "VVLayout"
  spec.version      = "0.1.1"
  spec.summary      = "VVLayout采用Masonry接口的高性能的Frame布局框架"
  spec.homepage     = "https://github.com/chinaxxren/VVLayout"
  spec.license      = "MIT"
  spec.author       = { "chinaxxren" => "182421693@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/chinaxxren/VVLayout.git", :tag => "#{spec.version}" }
  spec.source_files  = "VVLayout/Source", "VVLayout/Source/**/*.*"
  spec.frameworks  = "UIKit"
end
