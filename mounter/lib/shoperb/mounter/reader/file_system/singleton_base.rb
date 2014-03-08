module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class SingletonBase < Base

          def config_path name
            File.join(self.runner.path, 'config',"#{name.underscore}.yml")
          end

          def read
            name = self.class.name.split('::').last.gsub('Reader','')
            config_path = config_path(name)

            data = self.read_yaml(config_path)

            klass = "Shoperb::Mounter::Models::#{name}".constantize
            klass.mounting_point = self.runner.mounting_point
            instance = klass.instance
            data.each do |key, value|
              instance.send("#{key}=", value)
            end
            yield(instance) if block_given?

            instance
          end

        end

      end
    end
  end
end