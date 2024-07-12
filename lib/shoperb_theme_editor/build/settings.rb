require 'tty-prompt'

module Shoperb
  module Theme
    module Editor
      module Build
        class Settings
          def initialize(section_handle, json_manager)
            @section_handle = section_handle
            @json_manager = json_manager
            @prompt = TTY::Prompt.new
          end

          def add_settings
            loop do
              show_current_settings(@json_manager.json_content["settings"])
              break unless @prompt.yes?('Do you want to add or delete a setting?')

              action = @prompt.select('Choose an action:', %w[Add Delete])

              case action
              when 'Add'
                add_setting(@json_manager.json_content["settings"])
              when 'Delete'
                delete_setting(@json_manager.json_content["settings"])
              end

              File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                file.write(JSON.pretty_generate(@json_manager.json_content))
              end
            end
          end

          def add_block_settings(block_name)
            block = @json_manager.json_content["blocks"].find { |b| b["name"] == block_name }
            return unless block

            loop do
              show_current_settings(block["settings"])
              break unless @prompt.yes?("Do you want to add or delete a setting to the block '#{block_name}'?")

              action = @prompt.select('Choose an action:', %w[Add Delete])

              case action
              when 'Add'
                add_setting(block["settings"])
              when 'Delete'
                delete_setting(block["settings"])
              end

              File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                file.write(JSON.pretty_generate(@json_manager.json_content))
              end
            end
          end

          private

          def add_setting(settings)
            handle = @prompt.ask('Enter the config handle:', required: true)
            type = @prompt.select('Select the config type:', %w[text richtext select number checkbox radio range color video collection product menu image blog_post category subcategory])

            additional_args = case type
                              when 'text', 'richtext'
                                default = @prompt.ask('Enter the default value for text:', default: '')
                                [default]
                              when 'select', 'radio'
                                default = @prompt.ask('Enter the default value for select:', required: true)
                                options = []
                                loop do
                                  value = @prompt.ask('Enter an option value (leave empty to finish):')
                                  break if value.nil? || value.strip.empty?
                                  option_handle = @prompt.ask('Enter the option handle:')
                                  options << { "value" => value, "handle" => option_handle }
                                end
                                [default, options]
                              when 'range'
                                min = @prompt.ask('Enter the minimum value for range:', convert: :int, required: true)
                                max = @prompt.ask('Enter the maximum value for range:', convert: :int, required: true)
                                step = @prompt.ask('Enter the step value for range:', convert: :int, required: true)
                                [min, max, step]
                              when 'checkbox'
                                default = @prompt.yes?('Should the checkbox default to true?')
                                [default]
                              when 'subcategory'
                                sub_settings = []
                                loop do
                                  sub_handle = @prompt.ask('Enter the sub-setting handle:', required: true)
                                  sub_type = @prompt.select('Select the sub-setting type:', %w[text richtext select number checkbox radio range color video collection product menu image blog_post category])
                                  sub_default = @prompt.ask('Enter the default value for sub-setting:', default: '')
                                  sub_settings << build_config_item(sub_handle, sub_type, sub_default)
                                  break unless @prompt.yes?('Do you want to add another sub-setting?')
                                end
                                [sub_settings]
                              else
                                default = @prompt.ask("Enter the default value for #{type}:", default: '')
                                [default]
                              end

            settings << build_config_item(handle, type, *additional_args)
          end

          def delete_setting(settings)
            handles = settings.map { |s| s['handle'] }
            handle_to_delete = @prompt.select('Select the setting to delete:', handles)
            settings.reject! { |s| s['handle'] == handle_to_delete }
          end

          def show_current_settings(settings)
            if settings.empty?
              puts "No current settings."
            else
              puts "Current settings:"
              settings.each do |setting|
                puts "Handle: #{setting['handle']}, Type: #{setting['type']}, Default: #{setting['default']}"
                if setting['options']
                  puts "Options: #{setting['options'].map { |opt| "#{opt['value']}(#{opt['handle']})" }.join(', ')}"
                end
                if setting['min'] && setting['max'] && setting['step']
                  puts "Range: Min: #{setting['min']}, Max: #{setting['max']}, Step: #{setting['step']}"
                end
              end
            end
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
                "options" => args[1] || []
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
        end
      end
    end
  end
end