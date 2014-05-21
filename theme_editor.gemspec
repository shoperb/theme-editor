# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = 'shoperb-theme-editor'
  gem.version = '0.0.2'

  gem.authors  = ['Rainer Sai']
  gem.email    = ['rainer.sai@perfectline.co']
  gem.summary  = %q{shoperb_theme_editor is a theme manager for Shoperb}
  gem.homepage = 'http://www.shoperb.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'sinatra'
  gem.add_dependency 'sinatra-contrib'
  gem.add_dependency 'sinatra-flash'
  gem.add_dependency 'sinatra-asset-pipeline'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'actionview'
  gem.add_dependency 'actionpack'
  gem.add_dependency 'liquid'
  gem.add_dependency 'slop'
  gem.add_dependency 'oauth2'
  gem.add_dependency 'launchy'
  gem.add_dependency 'hashie'
  gem.add_dependency 'sprockets', '~> 2.0'
  gem.add_dependency 'rubyzip', '>= 1.0.0'

  gem.add_development_dependency 'pry'
end
