Pod::Spec.new do |s|
  s.name                      = "Akane"
  s.version                   = "0.16.0"
  s.source                    = { :git => "https://github.com/akane/Akane.git",
                                  :tag => s.version.to_s }

  s.summary                   = "Lightweight native iOS MVVM framework"
  s.description               = "Akane is a MVVM framework helping you to build safer, cleaner and more maintenable iOS native apps"
  s.homepage                  = "https://github.com/akane/Akane"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = 'pjechris', 'viteinfinite', 'akane', 'xebia'

  s.ios.deployment_target     = "8.0"
  s.requires_arc              = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Core/**/*.swift'
  end
  
  s.subspec 'Bindings' do |ss|
    ss.source_files = 'Bindings/**/*.swift'
    ss.dependency 'Bond', '~> 5.x'
  end

  s.subspec 'Collections' do |ss|
    ss.source_files = 'Collections/**/*.swift'
  end
end
