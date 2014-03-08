require 'active_support'
module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class ThemeReader < SingletonBase

          def read
            super do |theme|
              Shoperb::Mounter.locale = Shoperb::Mounter.locale

              theme.filepath = root_dir
            end
          end

          def root_dir
            File.join(self.runner.path)
          end

        end

      end
    end
  end
end