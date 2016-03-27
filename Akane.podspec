Pod::Spec.new do |s|
  s.name                      = "Akane"
  s.version                   = "0.12.0-beta.2"
  s.source                    = { :git => "https://github.com/akane/Akane.git",
                                  :tag => s.version.to_s }

  s.summary                   = "Lightweight native iOS MVVM framework"
  s.description               = "Akane is a MVVM framework helping you to build safer, cleaner and more maintenable iOS native apps"
  s.homepage                  = "https://github.com/akane/Akane"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = 'pjechris', 'akane', 'xebia'

  s.ios.deployment_target     = "8.0"
  s.source_files              = "Akane/**/*.swift"
  s.requires_arc              = true

  s.dependency 'Bond', '~> 4.x'
  s.dependency 'HasAssociatedObjects'
end
