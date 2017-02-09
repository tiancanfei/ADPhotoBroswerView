
Pod::Spec.new do |s|

  s.name         = "ADPhotoBroswerView"
  s.version      = "1.0.0"
  s.summary      = "图片浏览器"

  s.description  = <<-DESC
                   iOS图片浏览器，暂不支持本地图片浏览 ，模仿微信朋友圈图片浏览
                   DESC

  s.homepage     = "https://github.com/tiancanfei/ADPhotoBroswerView"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "安德航" => "bjwltiankong@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/tiancanfei/ADPhotoBroswerView.git", :tag => "#{s.version}" }

  s.source_files  = "APhotoBroswer/ADPhotoBroswerView/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  s.public_header_files = "APhotoBroswer/ADPhotoBroswerView/*.h"

  # s.framework  = "UIKit"
  s.frameworks = "UIKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'SDWebImage', '~> 3.7.6'
  s.dependency 'SVProgressHUD', '~> 2.0.3'

end
