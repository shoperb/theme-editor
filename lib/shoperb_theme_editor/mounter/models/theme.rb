module Shoperb module Theme module Editor
  module Mounter
    module Model
      #
      # Aggregating all theme data that we have
      # into Theme object, which might be used in
      # liquid drops/filters/tags
      #
      class Theme
        def spec
          Spec.new
        end

        def settings_data
          SettingsData.new
        end

        def cache_key
          SecureRandom.hex
        end

        class Spec
          def compile
            data["compile"]
          end

          def data
            JSON.parse(File.read(file).presence || "{}")
          end

          private

          def file
            File.join(Dir.pwd, "config", "spec.json")
          end
        end

        class SettingsData
          def data
            JSON.parse(File.read(file).presence || "{}")
          end

          private

          def file
            File.join(Dir.pwd, "config", "settings_data.json")
          end
        end
      end
    end
  end
end end end
