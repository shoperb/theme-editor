# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = "shoperb-theme-editor"
  gem.version = "0.4.1"

  gem.authors  = ["Rainer Sai"]
  gem.email    = ["rainer.sai@perfectline.co"]
  gem.summary  = %q{shoperb_theme_editor is a theme manager for Shoperb}
  gem.homepage = "http://www.shoperb.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra", "~> 1"
  gem.add_dependency "sinatra-contrib", "~> 1"
  gem.add_dependency "sinatra-flash"
  gem.add_dependency "sprockets-helpers"
  gem.add_dependency "activesupport", "~> 4"
  gem.add_dependency "actionview", "~> 4"
  gem.add_dependency "actionpack", "~> 4"
  gem.add_dependency "liquid"
  gem.add_dependency "sprockets"
  gem.add_dependency "coffee-script", "~> 2"
  gem.add_dependency "sass", "~> 3"
  gem.add_dependency "haml", "~> 4"
  gem.add_dependency "slop", "~> 3"
  gem.add_dependency "colorize"
  gem.add_dependency "oauth2", "~> 1"
  gem.add_dependency "rollbar", "~> 1"
  gem.add_dependency "launchy", "~> 2"
  gem.add_dependency "rubyzip", "~> 1"

  gem.add_development_dependency "pry"
end
