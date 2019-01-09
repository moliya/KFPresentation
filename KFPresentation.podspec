Pod::Spec.new do |s|

  s.name          = "KFPresentation"
  s.version       = "1.0.1"
  s.summary       = "自定义模态控制器的内容大小、背景配置等"
  s.homepage      = "https://github.com/moliya/KFPresentation"
  s.license       = "MIT"
  s.author        = {'Carefree' => '946715806@qq.com'}
  s.source        = { :git => "https://github.com/moliya/KFPresentation.git", :tag => s.version}
  s.requires_arc  = true
  s.platform      = :ios, '9.0'

  s.source_files  = "Sources/*.{h,m}"
  
end
