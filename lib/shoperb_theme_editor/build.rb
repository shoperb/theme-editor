require_relative 'build/json'
require_relative 'build/liquid'
require_relative 'build/section'
require_relative 'build/settings'

module Shoperb
  module Theme
    module Editor
      module_function

      def with_configuration(options)
        # Implement configuration logic here
        yield if block_given?
      end

      def create_section(section_handle)
        Build::Section.new(section_handle)
      end

      def create_or_update_json_file(section_handle)
        Build::Json.new(section_handle).create_or_update_json_file
      end

      def create_or_update_liquid_file(section_handle)
        Build::Liquid.new(section_handle).create_or_update_liquid_file
      end

      def add_settings(section_handle)
        json_manager = Build::Json.new(section_handle)
        json_manager.create_or_update_json_file
        Build::Settings.new(section_handle, json_manager).add_settings
      end

      def add_block_settings(section_handle, block_name)
        json_manager = Build::Json.new(section_handle)
        json_manager.create_or_update_json_file
        Build::Settings.new(section_handle, json_manager).add_block_settings(block_name)
      end
    end
  end
end