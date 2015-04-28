Pod::Spec.new do |s|
  s.name         = 'RLDTableViewSuite'
  s.version      = '0.2.0'
  s.homepage     = 'https://github.com/rlopezdiez/RLDTableViewSuite.git'
  s.summary      = 'Reusable table view controller, data source and delegate for all your UITableView needs'
  s.authors      = { 'Rafael Lopez Diez' => 'https://www.linkedin.com/in/rafalopezdiez' }
  s.source       = { :git => 'https://github.com/rlopezdiez/RLDTableViewSuite.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.{h,m}'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
end
