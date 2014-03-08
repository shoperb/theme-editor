$:.unshift File.expand_path(File.dirname(__FILE__))

# Force encoding to UTF-8
Encoding.default_internal = Encoding.default_external = 'UTF-8'

# Remove I18n warnings
require 'i18n'
I18n.config.enforce_available_locales = true

require 'logger'
require 'colorize'

require 'active_support'
require 'active_support/core_ext'
require 'stringex'
require 'tempfile'
require 'digest/sha1'
require 'chronic'

require 'tilt'
require 'sprockets'
require 'sprockets-sass'
require 'haml'
require 'compass'
require 'pry'

require 'httmultiparty'
require 'mime/types'

# Utils
require 'shoperb/mounter/utils/hash'
require 'shoperb/mounter/utils/yaml'
require 'shoperb/mounter/utils/string'
require 'shoperb/mounter/utils/output'
require 'shoperb/mounter/utils/yaml_front_matters_template'
require 'shoperb/mounter/utils/ignoring_array'

# Main
require 'shoperb/mounter/version'
require 'shoperb/mounter/exceptions'
require 'shoperb/mounter/config'
require 'shoperb/mounter/mounting_point'

# Extensions
require 'shoperb/mounter/extensions/httmultiparty'
require 'shoperb/mounter/extensions/sprockets'
require 'shoperb/mounter/extensions/compass'
require 'shoperb/mounter/extensions/tilt/css'

# Models
require 'shoperb/mounter/models'

# Readers: Filesystem / API
require 'shoperb/mounter/reader'

# Writer: Filesystem
require 'shoperb/mounter/writer/runner'
require 'shoperb/mounter/writer/file_system'

module Shoperb

  module Mounter

    TEMPLATE_EXTENSIONS = %w(liquid haml)

    @@logger = ::Logger.new(STDOUT).tap { |log| log.level = ::Logger::DEBUG }

    @@mount_point = nil

    # default locale
    @@locale = I18n.locale

    def self.mount(options)
      @@mount_point = Shoperb::Mounter::Config[:reader].run!(options)
    end

    def self.logger
      @@logger
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.locale
      @@locale
    end

    def self.locale=(locale)
      @@locale = locale.to_sym
    end

    def self.with_locale(locale, &block)
      tmp, @@locale = @@locale, locale.try(:to_sym) || @@locale
      yield.tap do
        @@locale = tmp
      end
    end

  end

end