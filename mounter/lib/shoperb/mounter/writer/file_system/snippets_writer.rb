module Shoperb
  module Mounter
    module Writer
      module FileSystem

        class SnippetsWriter < Base

          # It creates the snippets folder
          def prepare
            super
            self.create_folder 'app/views/snippets'
          end

          # It writes all the snippets into files
          def write
            self.mounting_point.snippets.each do |filepath, snippet|
              self.output_resource_op snippet

              # Note: we assume the current locale is the default one
              snippet.translated_in.each do |locale|
                default_locale = locale.to_sym == self.mounting_point.default_locale.to_sym

                Shoperb::Mounter.with_locale(locale) do
                  self.write_snippet_to_fs(snippet, filepath, default_locale ? nil : locale)
                end
              end

              self.output_resource_op_status snippet
            end
          end

          protected

          # Write into the filesystem the file which stores the snippet template
          # The file is localized meaning a same snippet could generate a file for each translation.
          #
          # @param [ Object ] snippet The snippet
          # @param [ String ] filepath The path to the file
          # @param [ Locale ] locale The locale, nil if default locale
          #
          def write_snippet_to_fs(snippet, filepath, locale)
            _filepath = "#{filepath}.liquid"
            _filepath.gsub!(/.liquid$/, ".#{locale}.liquid") if locale

            unless snippet.template.blank?
              _filepath = File.join('app', 'views', 'snippets', _filepath)

              self.open_file(_filepath) do |file|
                file.write(snippet.source)
              end
            end
          end

        end

      end
    end
  end
end