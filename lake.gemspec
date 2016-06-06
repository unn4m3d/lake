Gem::Specification.new do |s|
  s.name        = 'lake'
  s.version     = '0.1.5'
  s.licenses    = ['MIT']
  s.executables << "lake"
  s.executables << "lake-gen"
  s.summary     = "Lake - a Make-style build system"
  s.description = "Lake - a Make-style build system with Ruby syntax"
  s.authors     = ["Stepan unn4m3d Melnikov"]
  s.email       = 'smelnikov871@gmail.com'
  s.files       = [
    'lib/lake.rb',
    'lib/lake/utils.rb',
    'lib/lake/gen.rb',
    'lib/lake/gen/erb.rb'
  ]
  s.homepage    = 'https://github.com/unn4m3d/lake'
end
