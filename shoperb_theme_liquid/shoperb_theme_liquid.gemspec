# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = "shoperb-theme-liquid"
  gem.version = "0.0.4"

  gem.authors  = ["Rainer Sai"]
  gem.email    = ["rainer.sai@perfectline.co"]
  gem.summary  = %q{shoperb_liquid is a liquid for Shoperb}
  gem.homepage = "http://www.shoperb.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "liquid/lib"]

  gem.add_dependency "liquid", "3.0.0"
  gem.add_dependency "activesupport", "4.2.10"
  gem.add_dependency "actionpack", "4.2.10"
end