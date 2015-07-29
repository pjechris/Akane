Pod::Spec.new do |s|
  s.name		  = "Akane"
  s.version		  = "0.9.7"
  s.source		  = { :git => "https://github.com/akane/Akkane.git",
  		     	      :tag => s.version.to_s }

  s.summary          	  = "iOS MVVM modern framework"
  s.description           = "For developers who want to build beautiful apps with beautiful code"
  s.homepage              = "https://github.com/akane/Akkane"
  s.license		  = { :type => "MIT", :file => "LICENSE" }
  s.author                = 'pjechris', 'akane'

  s.ios.deployment_target = "7.0"
  s.source_files    	  = "Akane/**/*.{h,m}"
  s.prefix_header_file    = "Akane/#{s.name}.h"
  s.requires_arc 	  = true

  s.dependency		  'EventListener'
end
