Pod::Spec.new do |s|
  s.name         = "LinearAlgebraExtensions"
  s.version      = "0.0.1"
  s.summary      = "Swift extensions for LinearAlgebra framework"
  s.description  = <<-DESC
                   Extensions to simplify the use of the LinearAlgebra framework on iOS 8 and OS X 10.10 utilising Swift operator overloading
                   DESC
  s.license      = {
    :type => "MIT",
    :file => "LICENSE"
  }
  s.author       = { "Damien Pontifex" => "damien.pontifex@gmail.com" }
  s.homepage     = "https://github.com/damienpontifex/LinearAlgebraExtensions"
  s.social_media_url   = "http://twitter.com/DamienPontifex"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { 
    :git => "https://github.com/damienpontifex/LinearAlgebraExtensions.git",
    :tag => "0.0.1"
  }
  s.source_files = "LinearAlgebraExtensions/**/*.swift"
  s.requires_arc = true
end
