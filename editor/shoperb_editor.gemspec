# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shoperb/editor/version'

Gem::Specification.new do |gem|
  gem.name          = 'shoperb_editor'
  gem.version       = Shoperb::Editor::VERSION


  gem.authors       = ['Didier Lafforgue', 'Rodrigo Alvarez']
  gem.email         = ['did@shoperb.com', 'papipo@gmail.com']
  gem.description   = %q{The Shoperb editor is a site generator for the Shoperb engine}
  gem.summary       = %q{The Shoperb editor is a site generator for the Shoperb engine powered by all the efficient and modern HTML development tools (Haml, SASS, Compass, Less).}
  gem.homepage      = 'http://www.shoperb.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.executables   = ['editor']

  gem.add_dependency 'thor'
  gem.add_dependency 'thin',                  '~> 1.6.1'
  gem.add_dependency 'activesupport',         '4.0.2'
  gem.add_dependency 'actionpack',            '4.0.2'
  gem.add_dependency 'RedCloth',              '~> 4.2.8'
  gem.add_dependency 'redcarpet',             '~> 3.0.0'
  gem.add_dependency 'rails',            '4.0.2'
  gem.add_dependency 'shoperb_mounter'
  gem.add_dependency 'liquid'
  gem.add_dependency 'sprockets',             '~> 2.0'
  gem.add_dependency 'sprockets-sass',        '~> 1.0.1'
  gem.add_dependency 'rack-cache',            '~> 1.1'
  gem.add_dependency 'better_errors',         '~> 1.0.1'
  gem.add_dependency 'rubyzip',               '~> 1.1.0'

  gem.add_dependency 'listen',                '~> 2.4.0'

  gem.add_dependency 'httmultiparty',         '0.3.10'
  gem.add_dependency 'will_paginate',         '~> 3.0.3'

  gem.add_dependency 'faker',                 '~> 0.9.5'

  gem.add_development_dependency 'rake',      '~> 10.0.4'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'launchy'
end
