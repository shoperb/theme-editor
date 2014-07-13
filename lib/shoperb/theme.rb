require "zip"
require "fileutils"

module Shoperb
  module Theme
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

    class << self

      def init name="blank"
        raise "No such template, possible options are 'blank', 'bootstrap', 'foundation'" unless ["blank", "bootstrap", "foundation"].include?(name)
        template_path = File.expand_path("../init/#{name}", __FILE__)
        FileUtils.cp_r("#{template_path}/.", base)
      end

      def matchers compilable: false
        compilable ? COMPILABLE : FILES
      end

      def base
        Pathname.new(Dir.pwd)
      end

      def handle
        Pathname.new(Shoperb.config["handle"] ? File.expand_path("../#{Shoperb.config["handle"]}") : base)
      end

      def pack
        compile
        zip = Zip::OutputStream.write_buffer do |out|
          files do |file|
            filename = Pathname.new(file).relative_path_from(base)
            out.put_next_entry("#{handle.basename}/#{filename}")
            out.write File.read(file)
          end
        end
        file = File.new("#{handle.basename}.zip", "w+b")
        file.write(zip.string)
        file.path
      ensure
        file.close
      end

      def unpack file, directory
        Zip::File.open(file) { |zip_file|
          Shoperb.config["handle"] = zip_file.entries.first.name.split("/").first
          zip_file.each { |entry|
            name = entry.name.gsub(/\A#{Shoperb.config["handle"]}\//, "")
            extract_path = File.join(directory || ".", name)
            FileUtils.mkdir_p(File.dirname(extract_path), verbose: Shoperb.config["verbose"])
            FileUtils.rm_r(extract_path, verbose: Shoperb.config["verbose"]) if File.exists?(extract_path)
            entry.extract(extract_path)
          }
        }
      ensure
        if File.exists?(file)
          file.close
          file.unlink
        end
      end

      def clone_models directory
        data_path = "#{directory}/data"
        FileUtils.mkdir_p(data_path, verbose: Shoperb.config["verbose"])
        files = Dir["#{File.expand_path("../mounter/default_models", __FILE__)}/*.yml"]
        files.delete_if { |file| File.exists?(File.join(data_path, Pathname.new(file).basename)) }
        FileUtils.cp files, data_path, verbose: Shoperb.config["verbose"]
      end

      def compile
        files(compilable: true) do |file|
          case file
            when /(#{base}\/.*).coffee/
              compile_coffeescript file, $1
            when /(#{base}\/.*).(sass|scss)/
              compile_sass file, $1, $2
            when /(#{base}\/.*).haml/
              compile_haml file, $1
          end
        end
      end

      def files compilable: false
        matchers(compilable: compilable).each do |matcher|
          Dir[File.join(base, matcher)].each do |file|
            yield(file)
          end
        end
      end

      def compile_coffeescript file, target
        require "coffee_script"
        write_file(target) { CoffeeScript.compile(File.read(file)) }
      end

      def compile_sass file, target, style
        require "sass"
        write_file(target) { Sass::Engine.new(File.read(file), syntax: style).render }
      end

      def compile_haml file, target
        require "haml"
        write_file(target) { Haml::Engine.new(File.read(file)).render }
      end

      def write_file target
        File.open(target, "w+") { |f| f.write(yield) }
      end

    end
  end
end