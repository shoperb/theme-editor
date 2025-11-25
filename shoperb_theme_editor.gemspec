# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name    = "shoperb-theme-editor"
  gem.version = "0.8.0"
  gem.required_ruby_version = ">= 3.2.0"

  gem.authors  = ["Shoperb"]
  gem.email    = ["engineering@shoperb.com"]
  gem.summary = "CLI toolkit for building, editing, and managing Shoperb storefront themes."
  gem.homepage = "https://shoperb.dev"
  gem.license = "MIT"

  gem.files = Dir[
    "bin/*",
    "lib/**/*",
    "shoperb_theme_editor.gemspec",
    "README*",
    "LICENSE*",
    "CONTRIBUTING*",
  ].select { |f| File.file?(f) }
  gem.require_paths = ["lib"]
  gem.bindir = "bin"
  gem.executables = ["shoperb"]
  gem.metadata = {
    "rubygems_mfa_required" => "true",
    "homepage_uri"=> "https://www.shoperb.com",
    "documentation_uri"=> "https://shoperb.dev",
    "source_code_uri"  => "https://github.com/shoperb/theme-editor",
    "bug_tracker_uri"  => "https://github.com/shoperb/theme-editor/issues"
  }

  gem.add_dependency "webrick", "~> 1.8"
  gem.add_dependency "sinatra", "~> 3.0"
  gem.add_dependency "sinatra-contrib", "~> 3.0"
  gem.add_dependency "sinatra-flash", "~> 0.3"

  gem.add_dependency "pagy", "~> 43.1.0"
  gem.add_dependency "activesupport", "~> 8.1"
  gem.add_dependency "actionpack", "~> 8.1"
  gem.add_dependency "shoperb_liquid", "~> 0.0.1"
  gem.add_dependency "artisans", "~> 2.0"
  gem.add_dependency "sentry-raven", "~> 3.1"      # (or migrate to sentry-ruby, "~> 5.0")
  gem.add_dependency "tty-prompt", "~> 0.23"

  gem.add_dependency "coffee-script", "~> 2"
  gem.add_dependency "sass", "~> 3"
  gem.add_dependency "haml", "~> 7"
  gem.add_dependency "slop", "~> 3"
  gem.add_dependency "patron", "~> 0.13"
  gem.add_dependency "sqlite3", "~> 2.7"
  gem.add_dependency "sequel", "~> 5.0"
  gem.add_dependency "colorize", "~> 1.1"
  gem.add_dependency "oauth2", "~> 2"
  gem.add_dependency "faraday", "~> 2"
  gem.add_dependency "faraday-multipart", "~> 1.0"
  gem.add_dependency "launchy", "~> 2.5"
  gem.add_dependency "rubyzip", "~> 3.2.2"
  gem.add_dependency "pry", "~> 0.15"
  gem.add_dependency "rubycritic", "~> 4.0"
end
