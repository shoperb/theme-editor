require 'tty-prompt'
require_relative 'json'
require_relative 'liquid'
require_relative 'settings'

module Shoperb
  module Theme
    module Editor
      module Build
        class Section
          def initialize(section_handle)
            @section_handle = section_handle
            @prompt = TTY::Prompt.new
            @json_manager = Json.new(section_handle)
            @liquid_manager = Liquid.new(section_handle)
            @settings_manager = Settings.new(section_handle, @json_manager)

            create_or_update_section
          end

          private

          def create_or_update_section
            @json_manager.create_or_update_json_file
            @liquid_manager.create_or_update_liquid_file
            @settings_manager.add_settings
            ask_for_blocks
          end

          def ask_for_blocks
            if @prompt.yes?('Do you want to add blocks configuration?')
              max_blocks = @prompt.ask('Enter the maximum number of blocks:', convert: :int, required: true)
              @json_manager.add_blocks_to_json_file(max_blocks)
              add_blocks
            end
          end

          def add_blocks
            loop do
              break unless @prompt.yes?('Do you want to add a block?')
              block_type = @prompt.ask('Enter the block type:', required: true)
              block_name = @prompt.ask('Enter the block name:', required: true)

              @json_manager.add_block_to_json_file(block_type, block_name)
              @settings_manager.add_block_settings(block_name)
            end
          end
        end
      end
    end
  end
end