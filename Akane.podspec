Pod::Spec.new do |s|
  s.name                      = "Akane"
  s.version                   = "0.18.0"
  s.source                    = { :git => "https://github.com/akane/Akane.git",
                                  :tag => s.version.to_s }

  s.summary                   = "Lightweight native iOS MVVM framework"
  s.description               = "Akane is a MVVM framework helping you to build safer, cleaner and more maintenable iOS native apps"
  s.homepage                  = "https://github.com/akane/Akane"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = 'pjechris', 'akane', 'xebia'

  s.ios.deployment_target     = "8.0"
  s.requires_arc              = true

  s.default_subspecs          = "Core", "Bond"

  s.subspec 'Core' do |ss|
    ss.source_files = "Akane/Akane/**/*.swift"

    ss.dependency 'HasAssociatedObjects'
  end

  s.subspec 'Bond' do |ss|
    ss.source_files = "Akane/Bond/**/*.swift"

    ss.dependency 'Bond', '~> 6.x'
    ss.dependency 'Akane/Core'
  end
end
