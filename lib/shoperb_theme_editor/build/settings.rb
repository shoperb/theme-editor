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

          def add_settings(verbose_mode = false)
            loop do
              if @json_manager.json_content["settings"].empty?
                verbose_mode && puts("DEBUG: No current settings found.")

                handle = @prompt.ask('Enter the config handle:', required: true)
                type = @prompt.select('Select the config type:', %w[text richtext select number checkbox radio range color video collection product menu image blog_post category subcategory], per_page: 18)
                additional_args = collect_additional_args(type, verbose_mode)

                verbose_mode && puts("DEBUG: Adding new setting - Handle: #{handle}, Type: #{type}, Additional Args: #{additional_args.inspect}")

                @json_manager.add_config(handle, type, *additional_args)

                File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                  file.write(JSON.pretty_generate(@json_manager.json_content))
                end

              else
                handle = @prompt.ask('Enter the config handle:', required: true) do |q|
                  q.validate { |input| @json_manager.json_content["settings"].none? { |s| s["handle"] == input } }
                  q.messages[:valid?] = 'Handle must be unique'
                end
                type = @prompt.select('Select the config type:', %w[text richtext select number checkbox radio range color video collection product menu image blog_post category subcategory], per_page: 18)
                additional_args = collect_additional_args(type, verbose_mode)

                verbose_mode && puts("DEBUG: Adding new setting - Handle: #{handle}, Type: #{type}, Additional Args: #{additional_args.inspect}")

                @json_manager.add_config(handle, type, *additional_args)

                File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                  file.write(JSON.pretty_generate(@json_manager.json_content))
                end
              end

              break unless @prompt.yes?('Do you want to add another setting?')
            end
          end

          def modify_setting(setting_handle, verbose_mode = false)
            settings = @json_manager.json_content["settings"]
            setting = settings.find { |s| s["handle"] == setting_handle }

            if setting
              type = setting["type"]
              handle = setting["handle"]

              verbose_mode && puts("DEBUG: Modifying setting - Handle: #{handle}, Type: #{type}")

              loop do
                options = [
                  { name: "Handle: #{handle}", value: :handle },
                  { name: "Type: #{type}", value: :type },
                  { name: "Default: #{setting['default']}", value: :default },
                  { name: "", disabled: "" },
                  { name: "+ Save", value: :save },
                  { name: "- Remove", value: :remove }
                ]
                option = @prompt.select('Select an option to modify:', options, per_page: 18)

                case option
                when :handle
                  new_handle = @prompt.ask('Enter the new handle:', default: handle)
                  setting["handle"] = new_handle
                when :type
                  new_type = @prompt.select('Select the new type:', %w[text richtext select number checkbox radio range color video collection product menu image blog_post category subcategory], per_page: 18, default: type)
                  setting["type"] = new_type
                  additional_args = collect_additional_args(new_type, verbose_mode)
                  setting.merge!(build_config_item(new_handle, new_type, *additional_args))
                when :default
                  new_default = @prompt.ask('Enter the new default value:', default: setting['default'])
                  setting["default"] = new_default
                when :remove
                  settings.delete(setting)
                  break
                when :save
                  break
                end

                verbose_mode && puts("DEBUG: Updated setting - #{setting.inspect}")
              end

              File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                file.write(JSON.pretty_generate(@json_manager.json_content))
              end

              @prompt.say("Setting updated successfully.")
            else
              @prompt.say("Setting not found.")
            end
          end

          def delete_settings(verbose_mode = false)
            settings = @json_manager.json_content["settings"]

            if settings.empty?
              @prompt.say("No settings to delete.")
              return
            end

            handle_to_delete = @prompt.select('Select the setting to delete:', settings.map { |s| "- #{s['handle']} (#{s['type']})" }, per_page: 18)

            verbose_mode && puts("DEBUG: Deleting setting: #{handle_to_delete}")

            setting = settings.find { |s| s["handle"] == handle_to_delete }

            if setting
              settings.delete(setting)
              File.open(File.join(Dir.pwd, "config/sections/#{@section_handle}.json"), 'w') do |file|
                file.write(JSON.pretty_generate(@json_manager.json_content))
              end
              @prompt.say("Setting deleted successfully.")
            else
              @prompt.say("Setting not found.")
            end
          end

          private

          def collect_additional_args(type, verbose_mode = false)
            case type
            when 'text', 'richtext'
              default = @prompt.ask('Enter the default value for text:', default: '')
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Default: #{default}")
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
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Default: #{default}, Options: #{options.inspect}")
              [default, options]
            when 'range'
              min = @prompt.ask('Enter the minimum value for range:', convert: :int, required: true)
              max = @prompt.ask('Enter the maximum value for range:', convert: :int, required: true)
              step = @prompt.ask('Enter the step value for range:', convert: :int, required: true)
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Min: #{min}, Max: #{max}, Step: #{step}")
              [min, max, step]
            when 'checkbox'
              default = @prompt.yes?('Should the checkbox default to true?')
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Default: #{default}")
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
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Sub-settings: #{sub_settings.inspect}")
              [sub_settings]
            else
              default = @prompt.ask("Enter the default value for #{type}:", default: '')
              verbose_mode && puts("DEBUG: Collected Args for #{type} - Default: #{default}")
              [default]
            end
          end

          def show_current_settings(settings, verbose_mode = false)
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
            verbose_mode && puts("DEBUG: Current settings - #{settings.inspect}")
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