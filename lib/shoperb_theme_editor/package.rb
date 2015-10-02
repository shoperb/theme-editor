require_relative "../../shoperb_theme_sprockets/lib/shoperb_theme_sprockets"

module Shoperb module Theme module Editor
  module Package

    extend self

    def self.sprockets
      @@sprockets_env ||= begin
        Shoperb::Theme::Sprockets::Environment.new(domain: Editor["oauth-site"], theme: Editor["handle"]) do |env|
          env.append_path "assets"
        end
      end
    end

    def unzip_exceptions
      folder = { "js" => "javascripts", "css" => "stylesheets" }
      (Editor["compile"] || {}).map do |k,v|
        v.map do |value|
          "assets/#{folder[k]}/#{value}.#{k}"
        end
      end.flatten
    end

    def unzip file
      Zip::File.open(file.path) { |zip_file|
        raise Error.new("Downloaded file is empty") unless zip_file.entries.any?
        Editor["handle"] = zip_file.entries.first.name.split("/").first
        zip_file.each { |entry|
          entry_name = Pathname.new(entry.name).cleanpath.to_s
          name = entry_name.gsub(/\A#{Editor["handle"]}\//, "")
          extract_path = Utils.base + name
          next if unzip_exceptions.include?(extract_path.to_s)
          FileUtils.mkdir_p extract_path.dirname
          Logger.notify "Extracting #{entry_name}" do
            entry.extract(extract_path) { true }
          end
        }
      }
    ensure
      Utils.rm_tempfile file
    end

    def zip
      zip = Zip::OutputStream.write_buffer do |out|
        Pathname.glob("**/*") do |file|
          pack_file file, out
        end
      end
      Utils.write_file("debug.zip") { zip.string } if Editor["verbose"]
      Utils.mk_tempfile zip.string, "#{handle.basename}-", ".zip"
    end

    private

    def pack_file file, out
      case file.to_s
        when /\A(assets\/(stylesheets\/((?:#{Editor["compile"]["css"].join("|")})\.(css(|\.sass|\.scss)|sass|scss))))\z/
          pack_compilable $~, file, out, "css"
        when /\A(assets\/(javascripts\/((?:#{Editor["compile"]["js"].join("|")})\.(js|coffee|js\.coffee))))\z/
          pack_compilable $~, file, out, "js"
        when /\A((layouts|templates)\/(.*\.liquid))\z/,
          /\A(assets\/((images|icons)\/(.*\.(png|jpg|jpeg|gif|swf|ico|svg|pdf))))\z/,
          /\A(assets\/(fonts\/(.*\.(eot|woff|ttf|woff2))))\z/,
          /\A(assets\/(javascripts\/(.*\.js)))\z/,
          /\A(assets\/(stylesheets\/(.*\.css)))\z/,
          /\A(translations\/.*\.json)\z/
          write_file(out, file)
          write_symlink(out, file, Pathname.new("cache") + $1.dup) # Use symlinks to save space
        when /\A((layouts|templates)\/(.*\.liquid))\.haml\z/
          write_file(out, file)
          write_file(out, Pathname.new("cache") + $1.dup) { Haml::Engine.new(file.read).render }
        when /\A(assets\/(javascripts\/(.*\.(js|coffee|js\.coffee))))\z/, /\A(assets\/(stylesheets\/(.*\.(css(|\.sass|\.scss)|sass|scss))))\z/
          write_file(out, file)
      end
    end

    def pack_compilable matchdata, file, out, type
      compiled = sprockets[matchdata[2]].to_s
      filename = "#{matchdata[1].gsub(".#{matchdata[4]}", "")}.#{type}"
      write_file(out, file)
      write_file(out, Pathname.new("cache") + filename) { compiled }
      write_file(out, Pathname.new(filename)) { compiled }
    end

    def handle
      Pathname.new(Editor["handle"])
    end

    def write_file out, file
      out.put_next_entry(zip_file_path = handle + file)
      content = block_given? ? yield : file.read
      Logger.notify "Packing #{file}" do
        out.write content
      end
    end

    def write_symlink out, current, target
      entry = out.put_next_entry(zip_file_path = handle + target)
      entry.instance_variable_set("@ftype", :symlink)
      entry.instance_variable_set("@filepath", target.to_s)
      out.write(current.relative_path_from(target).to_s)
    end

  end
end end end
