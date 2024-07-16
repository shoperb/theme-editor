require_relative 'build/json'
require_relative 'build/liquid'
require_relative 'build/section'
require_relative 'build/settings'

module Shoperb
  module Theme
    module Editor
      module_function

      def create_section(section_handle, section_name)
        section = Build::Section.new(section_handle, section_name)
        section.create_or_update_json_file
        section.create_or_update_liquid_file
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

      def modify_setting(section_handle, setting_handle)
        json_manager = Build::Json.new(section_handle)
        json_manager.create_or_update_json_file
        Build::Settings.new(section_handle, json_manager).modify_setting(setting_handle)
      end

      def delete_settings(section_handle)
        json_manager = Build::Json.new(section_handle)
        json_manager.create_or_update_json_file
        Build::Settings.new(section_handle, json_manager).delete_settings
      end

      def remove_section(section_handle)
        config_dir = File.join(Dir.pwd, "config/sections")
        liquid_dir = File.join(Dir.pwd, "sections")

        json_file_path = File.join(config_dir, "#{section_handle}.json")
        liquid_file_path = File.join(liquid_dir, "#{section_handle}.liquid")

        # Remove JSON config file
        if File.exist?(json_file_path)
          File.delete(json_file_path)
        else
          puts "JSON config file for section '#{section_handle}' not found."
        end

        # Remove Liquid template file
        if File.exist?(liquid_file_path)
          File.delete(liquid_file_path)
        else
          puts "Liquid template file for section '#{section_handle}' not found."
        end

        puts "Section '#{section_handle}' has been removed successfully."
      end
    end
  end
end