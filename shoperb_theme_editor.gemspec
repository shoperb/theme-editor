# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = "shoperb-theme-editor"
  gem.version = "0.7.7"

  gem.authors  = ["Rainer Sai"]
  gem.email    = ["rainer.sai@perfectline.co"]
  gem.summary  = %q{shoperb_theme_editor is a theme manager for Shoperb}
  gem.homepage = "http://www.shoperb.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "webrick"
  gem.add_dependency "sinatra"
  gem.add_dependency "sinatra-contrib"
  gem.add_dependency "sinatra-flash"

  gem.add_dependency "pagy"
  gem.add_dependency "activesupport", "5.2.2"
  gem.add_dependency "actionpack", "5.2.2"
  gem.add_dependency "shoperb_liquid"
  gem.add_dependency "artisans", "~> 2"
  gem.add_dependency "sentry-raven"

  gem.add_dependency "coffee-script", "~> 2"
  gem.add_dependency "sass", "~> 3"
  gem.add_dependency "haml", "~> 6"
  gem.add_dependency "slop", "~> 3"
  gem.add_dependency "patron"
  gem.add_dependency "active_hash", "~> 3"
  gem.add_dependency "colorize"
  gem.add_dependency "oauth2", "~> 2"
  gem.add_dependency "faraday-multipart"
  gem.add_dependency "launchy", "~> 2"
  gem.add_dependency "rubyzip", "~> 2"
  gem.add_dependency "pry"
  gem.add_dependency "rubycritic"
end
