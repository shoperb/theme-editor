module Shoperb
  module Theme
    module Editor
      class Init

        Editor.autoload_all self, "init"

        def self.available_templates
          ["theme-blank"]
        end

        def initialize template, handle
          template ||= "blank"
          unless self.class.available_templates.include?(template)
            raise Error.new("No such template, possible options are #{self.class.available_templates.map(&:inspect).to_sentence}")
          end

          url = URI.parse("https://github.com/shoperb/#{template}/archive/refs/heads/main.zip")
          tmp_zip = nil
          Logger.notify "Downloading #{template.inspect} template" do
            tmp_zip = download_to_tempfile(url, template: template)
          end

          Logger.notify "Extracting template into theme folder" do
            extract_zip_to_base(tmp_zip.path)
          end
        ensure
          Utils.rm_tempfile(tmp_zip) if defined?(tmp_zip)
        end

        private

        def download_to_tempfile(uri, limit = 5, template: "theme-blank")
          require "net/http"
          require "uri"
          require "tempfile"

          raise Error.new("Too many HTTP redirects while downloading template") if limit <= 0

          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
            request = Net::HTTP::Get.new(uri.request_uri)
            request["User-Agent"] = "shoperb-theme-editor"
            request["Accept"] = "application/zip, application/octet-stream"

            response = http.request(request)
            case response
            when Net::HTTPRedirection
              location = response["location"]
              raise Error.new("Redirect without Location header") unless location
              new_uri = URI.parse(location)
              new_uri = URI.join("#{uri.scheme}://#{uri.host}", location) unless new_uri.host
              return download_to_tempfile(new_uri, limit - 1)
            when Net::HTTPSuccess
              file = Tempfile.new([template.gsub(/[^a-zA-Z0-9\-_.]/, "-"), ".zip"])
              if response.body.nil? || response.body.empty?
                # Try reading body in chunks if not already loaded
                response.read_body { |chunk| file.write(chunk) }
              else
                file.write(response.body)
              end
              file.flush
              file.rewind
              raise Error.new("Downloaded archive has zero size") if File.size(file.path) == 0
              return file
            else
              raise Error.new("Failed to download template: #{response.code} #{response.message}")
            end
          end
        end

        def extract_zip_to_base(zip_path)
          require "zip"
          Zip::File.open(zip_path) do |zip|
            zip.each do |entry|
              next if entry.name_is_directory?
              relative = entry.name.split('/', 2)[1] || entry.name
              destination = (Utils.base + relative).to_s
              FileUtils.mkdir_p(File.dirname(destination))
              entry.extract(destination) { true }
            end
          end
        end

      end
    end
  end
end
