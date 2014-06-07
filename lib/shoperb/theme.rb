require 'zip'
require 'fileutils'

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
    }

    class << self

      def pack
        base = Pathname.new(Dir.pwd)
        handle = Pathname.new(Shoperb.config['handle'] ? File.expand_path("../#{Shoperb.config['handle']}") : base)
        zip = Zip::OutputStream.write_buffer do |out|
          FILES.each do |matcher|
            Dir[File.join(base, matcher)].each do |file|
              filename = Pathname.new(file).relative_path_from(base)
              out.put_next_entry("#{handle.basename}/#{filename}")
              out.write File.read(file)
            end
          end
        end
        file = File.new("#{handle.basename}.zip", 'w+b')
        file.write(zip.string)
        file.path
      ensure
        file.close
      end

      def unpack file, directory
        Zip::File.open(file) { |zip_file|
          Shoperb.config['handle'] = zip_file.entries.first.name.split('/').first
          zip_file.each { |entry|
            name = entry.name.gsub(/\A#{Shoperb.config['handle']}\//, '')
            extract_path = File.join(directory || '.', name)
            FileUtils.mkdir_p(File.dirname(extract_path), verbose: Shoperb.config['verbose'])
            FileUtils.rm_r(extract_path, verbose: Shoperb.config['verbose']) if File.exists?(extract_path)
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
        FileUtils.mkdir_p(data_path, verbose: Shoperb.config['verbose'])
        files = Dir["#{File.expand_path('../mounter/default_models', __FILE__)}/*.yml"]
        files.delete_if { |file| File.exists?(File.join(data_path, Pathname.new(file).basename)) }
        FileUtils.cp files, data_path, verbose: Shoperb.config['verbose']
      end

    end
  end
end