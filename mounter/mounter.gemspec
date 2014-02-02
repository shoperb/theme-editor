#!/usr/bin/env gem build
# encoding: utf-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'shoperb/mounter/version'

Gem::Specification.new do |s|
  s.name        = 'shoperb_mounter'
  s.version     = Shoperb::Mounter::VERSION
  s.platform    = Gem::Platform::RUBY

  # TODO: change
  s.authors     = ['Didier Lafforgue']
  s.email       = ['didier@nocoffee.fr']
  s.homepage    = 'http://www.locomotivecms.com'
  s.summary     = 'LocomotiveCMS Mounter'
  s.description = 'Mount any LocomotiveCMS site, from a template on the filesystem, a zip file or even an online engine'

  s.add_dependency 'tilt',                            '1.4.1'
  s.add_dependency 'sprockets',                       '~> 2.0'
  s.add_dependency 'sprockets-sass'
  s.add_dependency 'haml',                            '~> 4.0.3'
  s.add_dependency 'sass',                            '~> 3.2.12'
  s.add_dependency 'compass',                         '~> 0.12.2'
  s.add_dependency 'coffee-script',                   '~> 2.2.0'
  s.add_dependency 'less',                            '~> 2.2.1'
  s.add_dependency 'RedCloth',                        '~> 4.2.3'

  s.add_dependency 'tzinfo'
  s.add_dependency 'chronic',                         '~> 0.10.2'

  s.add_dependency 'rails',                           '4.0.2'
  s.add_dependency 'i18n',                            '~> 0.6.0'
  s.add_dependency 'stringex',                        '~> 2.0.3'

  s.add_dependency 'multi_json',                      '~> 1.7.3'
  s.add_dependency 'httmultiparty',                   '0.3.10'
  s.add_dependency 'json',                            '~> 1.8.0'
  s.add_dependency 'mime-types',                      '~> 1.19'

  s.add_dependency 'zip',                             '~> 2.0.2'
  s.add_dependency 'colorize',                        '~> 0.5.8'
  s.add_dependency 'logger'

  s.add_development_dependency 'rake',                '0.9.2'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'therubyracer',        '~> 0.11.4'
  s.add_development_dependency 'webmock',             '1.9.3'

  s.require_path = 'lib'

  s.files        = Dir.glob('lib/**/*')
end