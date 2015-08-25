# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = "shoperb-theme-sprockets"
  gem.version = "0.0.2"

  gem.authors  = ["Rainer Sai"]
  gem.email    = ["rainer.sai@perfectline.co"]
  gem.summary  = %q{shoperb_liquid is a liquid for Shoperb}
  gem.homepage = "http://www.shoperb.com"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib", "sprockets/lib"]

  gem.add_dependency "sprockets", "3.0.0.beta.6"
end
