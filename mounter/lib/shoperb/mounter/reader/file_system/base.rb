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

          def read
            name = self.class.name.split('::').last.gsub('Reader','')
            config_path = File.join(self.runner.path, 'config', 'models',"#{name.underscore}.yml")
            result = []
            if File.exists?(config_path)
              objs = self.read_yaml(config_path)
              if data = objs[name.downcase]
                data.each do |obj|
                  result << "Shoperb::Mounter::Models::#{name}".singularize.constantize.new(obj)
                end
              end
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