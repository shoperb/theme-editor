module Shoperb
  module Theme
    extend self

    COMPILABLE = %w{
      assets/javascripts/application.js.coffee
      assets/stylesheets/application.css.{sass,scss}
      templates/*.liquid.haml
      layouts/*.liquid.haml
    }.freeze

    FILES = (%w{
      translations/*.json
      assets/fonts/*.{eot,woff,ttf}
      assets/images/**/*.{png,jpg,jpeg,gif,swf,ico,svg,pdf}
      assets/javascripts/**/*.js
      layouts/*.liquid
      assets/stylesheets/**/*.css
      templates/*.liquid
      assets/javascripts/**/*.js.coffee
      assets/stylesheets/**/*.css.{sass,scss}
      templates/*.liquid.haml
      layouts/*.liquid.haml
    }).freeze

    mattr_accessor :sprockets do
      Sprockets::Environment.new do |env|
        env.instance_variable_set("@engines", env.engines.slice(".coffee", ".less", ".sass", "scss").freeze)
        env.append_path "assets/javascripts"
        env.append_path "assets/stylesheets"
      end
    end

    AVAILABLE_TEMPLATES = ["blank", "bootstrap", "foundation"]


    def init name="blank"
      raise Error.new("No such template, possible options are 'blank', 'bootstrap', 'foundation'") unless AVAILABLE_TEMPLATES.include?(name)
      basics_path = File.expand_path("../init/basics", __FILE__)
      template_path = File.expand_path("../init/#{name}", __FILE__)
      Logger.notify "Copying #{name} template" do
        FileUtils.cp_r("#{basics_path}/.", Utils.base)
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
      compile do
        zip = Zip::OutputStream.write_buffer do |out|
          files do |file|
            filename = Utils.rel_path(file)
            out.put_next_entry(zip_file_path = "#{handle.basename}/#{filename}")
            Logger.notify "Packing #{filename}" do
              out.write File.read(file)
            end
          end
        end
        Utils.mk_tempfile zip.string, "#{handle.basename}-", ".zip"
      end
    end

    def unpack file
      Zip::File.open(file.path) { |zip_file|
        raise Error.new("Downloaded file is empty") unless zip_file.entries.any?
        Shoperb["handle"] = zip_file.entries.first.name.split("/").first
        zip_file.each { |entry|
          entry_name = Pathname.new(entry.name).cleanpath.to_s
          name = entry_name.gsub(/\A#{Shoperb["handle"]}\//, "")
          extract_path = Utils.rel_path(Utils.base + name)
          Utils.mkdir File.dirname(extract_path)
          Logger.notify "Extracting #{entry_name}" do
            entry.extract(extract_path) { true }
          end
        }
      }
    ensure
      Utils.rm_tempfile file
    end

    def clone_models
      Utils.mkdir(data_path = Utils.base + "data")
      files = Pathname.glob("#{File.expand_path("../mounter/models/defaults", __FILE__)}/*")
      files.delete_if { |file| File.exists?(File.join(data_path, file.basename)) }
      Logger.notify "Copying default data" do
        FileUtils.cp files, data_path
      end if files.any?
    end

    def compile
      processed = []
      files(compilable: true) do |file|
        processed << case file.to_s
          when /(#{Utils.base}\/.*).coffee/
            compile_coffeescript Utils.rel_path(file), Utils.rel_path($1)
            Utils.rel_path($1)
          when /(#{Utils.base}\/.*).(sass|scss)/
            compile_sass Utils.rel_path(file), Utils.rel_path($1)
            Utils.rel_path($1)
          when /(#{Utils.base}\/.*).haml/
            compile_haml Utils.rel_path(file), Utils.rel_path($1)
            Utils.rel_path($1)
        end
      end
      yield
    ensure
      FileUtils.rm processed
    end

    def files compilable: false, &block
      matchers(compilable: compilable).each do |matcher|
        Pathname.glob(Utils.base + matcher, &block)
      end
    end

    def compile_coffeescript file, target
      Logger.notify "Compiling #{file}" do
        Utils.write_file(target) { sprockets[file.basename].to_s }
      end
    end

    def compile_sass file, target
      Logger.notify "Compiling #{file}" do
        Utils.write_file(target) { sprockets[file.basename].to_s }
      end
    end

    def compile_haml file, target
      Logger.notify "Compiling #{file}" do
        Utils.write_file(target) { Haml::Engine.new(File.read(file)).render }
      end
    end
  end
end
