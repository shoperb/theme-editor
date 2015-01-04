module Shoperb module Theme module Editor
  module Package

    extend self

    mattr_accessor :sprockets do
      Shoperb::Theme::Sprockets::Environment.new do |env|
        env.append_path "assets"
      end
    end

    def unzip file
      Zip::File.open(file.path) { |zip_file|
        raise Error.new("Downloaded file is empty") unless zip_file.entries.any?
        Editor["handle"] = zip_file.entries.first.name.split("/").first
        zip_file.each { |entry|
          entry_name = Pathname.new(entry.name).cleanpath.to_s
          name = entry_name.gsub(/\A#{Editor["handle"]}\//, "")
          extract_path = Utils.base + name
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
          case file.to_s
            when /\A((layouts|templates)\/(.*\.liquid))\z/,
              /\A(assets\/((images|icons)\/(.*\.(png|jpg|jpeg|gif|swf|ico|svg|pdf))))\z/,
              /\A(assets\/(fonts\/(.*\.(eot|woff|ttf))))\z/,
              /\A(assets\/(javascripts\/(.*\.js)))\z/,
              /\A(assets\/(stylesheets\/(.*\.css)))\z/,
              /\A(translations\/*\.json)\z/
              write_file(out, file)
              write_symlink(out, file, Pathname.new("cache") + $1) # Use symlinks to save space
            when /\A((layouts|templates)\/(.*\.liquid))\.haml\z/
              write_file(out, file)
              write_file(out, Pathname.new("cache") + $1) { Haml::Engine.new(file.read).render }
            when /\A(assets\/(javascripts\/(.*\.js)))\.coffee\z/, /\A(assets\/(stylesheets\/(.*\.css)))(\.sass|\.scss)\z/
              compiled = sprockets[$2].to_s
              write_file(out, file)
              write_file(out, $1) { compiled }
              write_file(out, Pathname.new("cache") + $1) { compiled }
          end
        end
      end
      Utils.mk_tempfile zip.string, "#{handle.basename}-", ".zip"
    end

    private

    def handle
      Pathname.new(Editor["handle"] ? Pathname.new(".." + Editor["handle"]) : Utils.base)
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
