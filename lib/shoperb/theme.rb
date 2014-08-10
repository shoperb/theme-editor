module Shoperb
  module Theme
    extend self

    FILES = %w{
      translations/*.json
      assets/fonts/*.{eot,woff,ttf}
      assets/images/**/*.{jpeg,jpg,gif,png}
      assets/javascripts/*.js
      layouts/*.liquid
      assets/stylesheets/*.css
      templates/*.liquid
    }.freeze

    COMPILABLE = %w{
      assets/javascripts/*.js.coffee
      assets/stylesheets/*.css.{sass,scss}
      templates/*.liquid.haml
      layouts/*.liquid.haml
    }.freeze

    AVAILABLE_TEMPLATES = ["blank", "bootstrap", "foundation"]


    def init name="blank"
      raise Error.new("No such template, possible options are 'blank', 'bootstrap', 'foundation'") unless AVAILABLE_TEMPLATES.include?(name)
      basics_path = File.expand_path("../init/basics", __FILE__)
      Logger.notify Utils.cp_desc("#{basics_path}/*") do
        FileUtils.cp_r("#{basics_path}/.", Utils.base)
      end
      template_path = File.expand_path("../init/#{name}", __FILE__)
      Logger.notify Utils.cp_desc("#{template_path}/*") do
        FileUtils.cp_r("#{template_path}/.", Utils.base)
      end
      clone_models

    end

    def matchers compilable: false
      compilable ? COMPILABLE : FILES
    end

    def handle
      Pathname.new(Shoperb["handle"] ? File.expand_path("../#{Shoperb["handle"]}") : Utils.base)
    end

    def pack
      compile
      zip_path = "#{handle.basename}.zip"
      zip = Zip::OutputStream.write_buffer do |out|
        files do |file|
          filename = Utils.rel_path(file)
          out.put_next_entry(zip_file_path = "#{handle.basename}/#{filename}")
          Logger.notify "Packing #{filename} to #{zip_path}/#{zip_file_path}" do
            out.write File.read(file)
          end
        end
      end
      file = File.new(zip_path, "w+b")
      file.write(zip.string)
      file.path
    ensure
      file.close if file
    end

    def unpack file
      Zip::File.open(file.path) { |zip_file|
        raise Error.new("Downloaded file is empty") unless zip_file.entries.any?
        Shoperb["handle"] = zip_file.entries.first.name.split("/").first
        zip_file.each { |entry|
          name = entry.name.gsub(/\A#{Shoperb["handle"]}\//, "")
          extract_path = Utils.rel_path(Utils.base + name)
          Utils.mkdir File.dirname(extract_path)
          Logger.notify "Extracting #{entry.name} to #{extract_path}" do
            entry.extract(extract_path) { true }
          end
        }
      }
    ensure
      if file && File.exists?(file)
        file.close
        file.unlink
      end
    end

    def clone_models
      Utils.mkdir(data_path = Utils.base + "data")
      files = Dir["#{File.expand_path("../mounter/models/defaults", __FILE__)}/*"]
      files.delete_if { |file| File.exists?(File.join(data_path, Pathname.new(file).basename)) }
      Logger.notify Utils.cp_desc(["defaults"]) do
        FileUtils.cp files, data_path
      end if files.any?
    end

    def compile
      files(compilable: true) do |file|
        case file
          when /(#{Utils.base}\/.*).coffee/
            compile_coffeescript Utils.rel_path(file), Utils.rel_path($1)
          when /(#{Utils.base}\/.*).(sass|scss)/
            compile_sass Utils.rel_path(file), Utils.rel_path($1), $2
          when /(#{Utils.base}\/.*).haml/
            compile_haml Utils.rel_path(file), Utils.rel_path($1)
        end
      end
    end

    def files compilable: false
      matchers(compilable: compilable).each do |matcher|
        Dir[File.join(Utils.base, matcher)].each do |file|
          yield(file)
        end
      end
    end

    def compile_coffeescript file, target
      Logger.notify "Compiling #{file} to #{target}" do
        Utils.write_file(target) { CoffeeScript.compile(File.read(file)) }
      end
    end

    def compile_sass file, target, style
      Logger.notify "Compiling #{file} to #{target}" do
        Utils.write_file(target) { Sass::Engine.new(File.read(file), syntax: style).render }
      end
    end

    def compile_haml file, target
      Logger.notify "Compiling #{file} to #{target}" do
        Utils.write_file(target) { Haml::Engine.new(File.read(file)).render }
      end
    end
  end
end
