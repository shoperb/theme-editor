require 'artisans'
require_relative "../../shoperb_theme_liquid/lib/shoperb_theme_liquid"

module Shoperb module Theme module Editor
  module Package

    extend self

    def unzip file
      Zip::File.open(file.path) { |zip_file|
        spec = zip_file.glob("*/config/spec.json").first
        if spec
          zip_handle = Editor.handle(zip_file.read(spec))
        else
          zip_handle = Editor["handle"] = zip_file.entries.first.name.split("/").first
        end
        zip_file.each { |entry|
          entry_name = Pathname.new(entry.name).cleanpath.to_s
          name = entry_name.gsub(/\A#{zip_handle}\//, "")
          extract_path = Utils.base + name
          FileUtils.mkdir_p extract_path.dirname
          Logger.notify "Extracting #{name}" do
            entry.extract(extract_path) { true }
          end
        }
      }
    ensure
      Utils.rm_tempfile file
    end

    def zip
      compiler = Editor.compiler("/system/assets/#{Editor["oauth-site"]}/#{Editor.handle}/")

      zip = Zip::OutputStream.write_buffer do |out|
        compiler.compiled_files do |path, content, type: :file|
          case type
            when :symlink
              write_symlink(out, path, content)
            else
              write_file(out, path) { content }
          end
        end
      end
      Utils.write_file("debug.zip") { zip.string } if Editor["verbose"]
      Utils.mk_tempfile zip.string, "#{handle.basename}-", ".zip"
    end

    def write_file out, file
      out.put_next_entry(zip_file_path = handle + file)
      content = block_given? ? yield : file.read
      if file.to_s[0..6] == "sources"
        out.write content
      else
        Logger.notify "Packing #{file}" do
          out.write content
        end
      end
    end

    def write_symlink out, current, target
      entry = out.put_next_entry(zip_file_path = handle + current)
      entry.instance_variable_set("@ftype", :symlink)
      entry.instance_variable_set("@filepath", target.to_s)
      Logger.notify "Packing #{current}" do
        out.write((handle + target).relative_path_from(handle + current).to_s[3..-1])
      end
    end

    def handle
      Pathname.new(Editor.handle)
    end

  end
end end end
