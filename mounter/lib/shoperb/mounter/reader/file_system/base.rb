module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class Base

          attr_accessor :runner, :items

          delegate :default_locale, :locales, to: :mounting_point

          def initialize(runner)
            self.runner  = runner
            self.items   = {}
          end

          def mounting_point
            self.runner.mounting_point
          end

          def config_path name
            File.join(self.runner.path, 'config', 'models',"#{name.underscore}.yml")
          end

          def read
            name = self.class.name.split('::').last.gsub('Reader','')
            config_path = config_path(name)
            result = []
            klass = "Shoperb::Mounter::Models::#{name}".singularize.constantize
            klass.mounting_point = mounting_point
            if File.exists?(config_path)
              objs = self.read_yaml(config_path)

              if data = objs[name.underscore]
                data.each do |obj|
                  result << klass.new(obj)
                end
              end if objs
            end
            result
          end


          protected

          # Return the locale of a file based on its extension.
          #
          # Ex:
          #   about_us/john_doe.fr.liquid.haml => 'fr'
          #   about_us/john_doe.liquid.haml => 'en' (default locale)
          #
          # @param [ String ] filepath The path to the file
          #
          # @return [ String ] The locale (ex: fr, en, ...etc) or nil if it has no information about the locale
          #
          def filepath_locale(filepath)
            locale = File.basename(filepath).split('.')[1]

            if locale.nil?
              # no locale, use the default one
              self.default_locale
            elsif self.locales.include?(locale)
              # the locale is registered
              locale
            elsif locale.size == 2
              # unregistered locale
              nil
            else
              self.default_locale
            end
          end

          # Open a YAML file and returns the content of the file
          #
          # @param [ String ] filepath The path to the file
          #
          # @return [ Object ] The content of the file
          #
          def read_yaml(filepath)
            YAML::load(File.open(filepath).read.force_encoding('utf-8'))
          end

        end

      end
    end
  end
end