Pod::Spec.new do |s|

  s.name         = "AppSendr-iOS-SDK"
  s.version      = "1.0"
  s.summary      = "iOS SDK for AppSendrPlus"

  s.description  = <<-DESC
                   Use AppSendr iOS SDK in your application to automatically download the latest version available on OTA.
                
                   DESC

  s.homepage     = "https://github.com/Lyc0s/AppSendr-iOS-SDK"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  
  s.author             = { "Jeremy Grenier" => "jeremy.grenier@epitech.eu" }
  s.social_media_url   = "https://twitter.com/jeremygrenier"



  s.platform     = :ios
  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/Lyc0s/AppSendr-iOS-SDK", :tag => "1.0" }


  s.source_files  = "AppSendr-iOS-SDK", "AppSendr-iOS-SDK/*.{h,m}"


  s.frameworks = "Foundation"


  s.requires_arc = true

end