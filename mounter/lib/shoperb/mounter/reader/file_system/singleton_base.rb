module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class SingletonBase < Base

          def read
            name = self.class.name.split('::').last.gsub('Reader','')
            config_path = File.join(self.runner.path, 'config', "#{name.downcase}.yml")

            data = self.read_yaml(config_path)
            instance = "Shoperb::Mounter::Models::#{name}".constantize.instance

            instance.marshal_load data
            instance.id = data["id"]

            yield(instance) if block_given?

            instance
          end

        end

      end
    end
  end
end