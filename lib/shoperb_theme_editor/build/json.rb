require 'fileutils'
require 'json'

module Shoperb
  module Theme
    module Editor
      module Build
        class Json
          attr_reader :json_content

          def initialize(section_handle)
            @section_handle = section_handle
            @json_content = {}
          end

          def create_or_update_json_file
            config_dir = File.join(Dir.pwd, "config/sections")
            FileUtils.mkdir_p(config_dir)
            json_file_path = File.join(config_dir, "#{@section_handle}.json")

            if File.exist?(json_file_path)
              @json_content = JSON.parse(File.read(json_file_path))
            else
              section_name = format_section_name(@section_handle)
              @json_content = {
                "name" => section_name,
                "generic" => true,
                "settings" => [],
                "blocks" => [],
                "default" => {
                  "blocks" => default_blocks
                }
              }
            end

            File.open(json_file_path, 'w') do |file|
              file.write(JSON.pretty_generate(@json_content))
            end
          end

          def add_blocks_to_json_file(max_blocks)
            json_file_path = File.join(Dir.pwd, "config/sections/#{@section_handle}.json")
            return unless File.exist?(json_file_path)

            @json_content["blocks"] ||= []
            @json_content["max_blocks"] = max_blocks

            File.open(json_file_path, 'w') do |file|
              file.write(JSON.pretty_generate(@json_content))
            end
          end

          def add_block_to_json_file(block_type, block_name)
            json_file_path = File.join(Dir.pwd, "config/sections/#{@section_handle}.json")
            return unless File.exist?(json_file_path)

            block = {
              "type" => block_type,
              "name" => block_name,
              "settings" => []
            }

            @json_content["blocks"] << block

            add_default_blocks(block_type)

            File.open(json_file_path, 'w') do |file|
              file.write(JSON.pretty_generate(@json_content))
            end
          end

          def add_config(handle, type, *args)
            json_file_path = File.join(Dir.pwd, "config/sections/#{@section_handle}.json")
            return unless File.exist?(json_file_path)

            @json_content["settings"] ||= []
            config_item = build_config_item(handle, type, *args)
            @json_content["settings"] << config_item

            File.open(json_file_path, 'w') do |file|
              file.write(JSON.pretty_generate(@json_content))
            end
          end

          private

          def format_section_name(handle)
            handle.split('_').map(&:capitalize).join(' ')
          end

          def build_config_item(handle, type, *args)
            case type
            when 'text', 'richtext'
              {
                "type" => type,
                "handle" => handle,
                "default" => args[0] || ""
              }
            when 'select', 'radio'
              {
                "type" => type,
                "handle" => handle,
                "default" => args[0] || "",
                "options" => build_select_options(args[1..-1])
              }
            when 'range'
              {
                "type" => "range",
                "handle" => handle,
                "min" => args[0],
                "max" => args[1],
                "step" => args[2]
              }
            when 'checkbox'
              {
                "type" => "checkbox",
                "handle" => handle,
                "default" => args[0]
              }
            when 'subcategory'
              {
                "type" => "subcategory",
                "handle" => handle,
                "settings" => args[0]
              }
            else
              {
                "type" => type,
                "handle" => handle,
                "default" => args[0] || ""
              }
            end
          end

          def build_select_options(options)
            options.each_slice(2).map do |value, handle|
              {
                "value" => value,
                "handle" => handle
              }
            end
          end

          def default_blocks
            Array.new(3) { { "type" => "collection" } }
          end

          def add_default_blocks(block_type)
            @json_content["default"] ||= {}
            @json_content["default"]["blocks"] ||= []

            default_blocks = @json_content["default"]["blocks"]

            if default_blocks.size < 3
              default_blocks << { "type" => block_type }
            else
              default_blocks.shift
              default_blocks << { "type" => block_type }
            end

            @json_content["default"]["blocks"] = default_blocks
          end
        end
      end
    end
  end
end