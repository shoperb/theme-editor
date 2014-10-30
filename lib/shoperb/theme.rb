module Shoperb
  module Theme
    extend self

    PREPROCESS = %w{
      assets/javascripts/application.js{.coffee,}
      assets/stylesheets/application.css{.sass,.scss,}
      assets/images/**/*.{png,jpg,jpeg,gif,swf,ico,svg,pdf}
      assets/icons/**/*.{png,jpg,jpeg,gif,swf,ico,svg,pdf}
      assets/fonts/*.{eot,woff,ttf}
      templates/*.liquid.haml
      layouts/*.liquid.haml
    }.freeze

    FILES = %w{
      translations/*.json
      assets/fonts/*.{eot,woff,ttf}
      assets/{images,icons}/**/*.{png,jpg,jpeg,gif,swf,ico,svg,pdf}
      assets/javascripts/**/*.js{.coffee,}
      assets/stylesheets/**/*.css{.sass,.scss,}
      templates/*.liquid{.haml,}
      layouts/*.liquid{.haml,}
      asset_cache/stylesheets/**/*.css
      asset_cache/javascripts/**/*.js
      asset_cache/fonts/**/*.{eot,woff,ttf}
      asset_cache/{images,icons}/**/*.{png,jpg,jpeg,gif,swf,ico,svg,pdf}
    }.freeze

    mattr_accessor :sprockets do
      Sprockets::Environment.new do |env|
        env.instance_variable_set("@engines", env.engines.slice(".coffee", ".less", ".sass", ".scss").freeze)
        Dir["assets/**/*"].each(&env.method(:append_path))
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

    def preprocessable &block
      PREPROCESS.each do |matcher|
        Pathname.glob(matcher, &block)
      end
    end

    def uploadable &block
      FILES.each do |matcher|
        Pathname.glob(matcher, &block)
      end
    end

    def handle
      Pathname.new(Shoperb["handle"] ? Pathname.new(".." + Shoperb["handle"]) : Utils.base)
    end

    def pack
      fill_asset_cache do
        zip = Zip::OutputStream.write_buffer do |out|
          uploadable do |file|
            out.put_next_entry(zip_file_path = handle + file)
            Logger.notify "Packing #{file}" do
              out.write file.read
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

    def clone_models
      FileUtils.mkdir_p(data_path = Utils.base + "data")
      files = Pathname.glob("#{File.expand_path("../mounter/models/defaults", __FILE__)}/*")
      files.delete_if { |file| File.exists?(File.join(data_path, file.basename)) }
      Logger.notify "Copying default data" do
        FileUtils.cp files, data_path
      end if files.any?
    end

    def fill_asset_cache
      preprocessable do |file|
        case file.to_s
          when /\Aassets\/(javascripts\/(application\.js))(\.coffee|)$\z/, /\Aassets\/(stylesheets\/(application\.css))(\.sass|\.scss|)$\z/
            FileUtils.mkdir_p((asset_cache + $1).dirname)
            compile_through_sprockets file, asset_cache + $1
          when /\Aassets\/(javascripts\/(?!(application\.js(\.coffee|)$)).*\.js(\.coffee|)$)\z/
            FileUtils.mkdir_p((asset_cache + $1).dirname)
            compile_through_sprockets file, asset_cache + $1
          when /\A(layouts|templates)\/(.*\.liquid).haml/
            compile_haml file, Utils.rel_path($1)
          when /\A(assets\/((images|icons)\/(.*\.(png|jpg|jpeg|gif|swf|ico|svg|pdf))))\z/, /\A(assets\/(fonts\/(.*\.(eot|woff|ttf))))\z/
            FileUtils.mkdir_p((asset_cache + $2).dirname)
            FileUtils.cp $1, asset_cache + $2
        end
      end
      yield
    ensure
      # FileUtils.rm_rf asset_cache
    end

    def asset_cache
      Pathname.new("asset_cache").tap { |path| FileUtils.mkdir_p path }
    end

    def assets_dir
      Pathname.new("assets").tap { |path| FileUtils.mkdir_p path }
    end

    def compile_through_sprockets file, target
      Logger.notify "Compiling #{file}" do
        Utils.write_file(target) { CustomSprockets::Compile.all[file.relative_path_from(Pathname.new("assets"))].to_s }
        target
      end
    end

    def compile_haml file, target
      Logger.notify "Compiling #{file}" do
        Utils.write_file(target) { Haml::Engine.new(File.read(file)).render }
        target
      end
    end
  end
end
