Gem::Specification.new do |s|
  s.name        = 'cdx-sync-server'
  s.version     = '0.0.0'
  s.date        = '2014-12-14'
  s.summary     = "CDX Sync Server"
  s.description = "CDX Sync Server, based on http://github.com/instedd/cdx-sync-server"
  s.authors     = ["Franco Bulgarelli"]
  s.email       = 'fbulgarelli@manas.com.ar'
  s.files       = Dir["lib/**/**"]
  s.homepage    = 'http://github.com/instedd/cdx-sync-server'
  s.license       = 'MIT'

  s.add_development_dependency "rspec"
  s.add_runtime_dependency 'filewatcher'

end