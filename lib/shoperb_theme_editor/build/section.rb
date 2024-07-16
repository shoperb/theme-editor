module Shoperb
  module Theme
    module Editor
      module Build
        class Section
          attr_reader :section_handle, :section_name

          def initialize(section_handle, section_name = nil)
            @section_handle = section_handle
            @section_name = section_name || section_handle.split('_').map(&:capitalize).join(' ')
          end

          def create_or_update_json_file
            sections_dir = File.join(Dir.pwd, "config/sections")
            FileUtils.mkdir_p(sections_dir)
            json_file_path = File.join(sections_dir, "#{section_handle}.json")

            json_content = if File.exist?(json_file_path)
                             JSON.parse(File.read(json_file_path))
                           else
                             { "name" => section_name, "settings" => [] }
                           end

            File.open(json_file_path, 'w') do |file|
              file.write(JSON.pretty_generate(json_content))
            end
          end

          def create_or_update_liquid_file
            sections_dir = File.join(Dir.pwd, "sections")
            FileUtils.mkdir_p(sections_dir)
            liquid_file_path = File.join(sections_dir, "#{section_handle}.liquid")

            liquid_content = <<-LIQUID
{% capture section_id %}{{section.id}}{% endcapture %}
{% cache "#{@section_handle}_section", section.updated_at, section_id %}
<section data-section-id="{{ section.id }}" data-type="#{@section_handle}" class="{{ section.id }} #{@section_handle}_section">
  ### YOUR CODE HERE ###
</section>
{% endcache %}
            LIQUID

            File.open(liquid_file_path, 'w') do |file|
              file.write(liquid_content)
            end
          end
        end
      end
    end
  end
end