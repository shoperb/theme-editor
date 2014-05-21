require 'zip'
require 'fileutils'

module Shoperb
  module Theme
    FILES = %w{
      config/translations.json
      fonts/*.(eot|woff|ttf)
      images/*
      javascripts/*.js
      layouts/*.liquid
      stylesheets/*.css
      templates/*.liquid
    }

    class << self

      def pack
        handle = Pathname.new(Dir.pwd)
        zip = Zip::OutputStream.write_buffer do |out|
          FILES.each do |matcher|
            Dir[File.join(Dir.pwd, matcher)].each do |file|
              filename = Pathname.new(file).relative_path_from(handle)
              out.put_next_entry("#{handle.basename}/#{filename}")
              out.write File.read(file)
            end
          end
        end

        file = File.new("#{handle}.zip", 'w+b')
        file.write(zip.string)
        file.path
      ensure
        file.close
      end

      def unpack file, directory
        directory = directory ? "./#{directory}" : '.'
        Zip::File.open(file) { |zip_file|
          handle = zip_file.entries.first.name.split('/').first
          zip_file.each { |entry|
            name = entry.name.gsub(/\A#{handle}\//, '')
            extract_path = File.join(directory || '.', name)
            FileUtils.mkdir_p(File.dirname(extract_path))
            FileUtils.rm_r(extract_path) if File.exists?(extract_path)
            entry.extract(extract_path)
          }
        }
      ensure
        if File.exists?(file)
          file.close
          file.unlink
        end
      end

    end
  end
end