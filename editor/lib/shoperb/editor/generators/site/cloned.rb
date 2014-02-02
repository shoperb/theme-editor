module Shoperb
  module Editor
    module Generators
      module Site

        # Template used when the remote Shoperb site is cloned
        # in order to have the minimal files.
        class Cloned < Base

          argument :connection_info

          def copy_sources
            directory('.', self.destination, { recursive: true }, {
              name:     self.name,
              version:  Shoperb::Editor::VERSION
            }.merge(self.connection_info))
          end

          def bundle_install
            super
          end

        end
      end
    end
  end
end