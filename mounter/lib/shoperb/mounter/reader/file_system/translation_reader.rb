module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class TranslationReader < SingletonBase

          def config_path
            File.join(self.runner.path, 'config',"translations.json")
          end

          def read
            name = self.class.name.split('::').last.gsub('Reader','')
            klass = "Shoperb::Mounter::Models::#{name}".constantize
            klass.mounting_point = self.runner.mounting_point
            instance = klass.instance
            instance.data = File.read(config_path).force_encoding('utf-8')
            instance
          end

        end

      end
    end
  end
end