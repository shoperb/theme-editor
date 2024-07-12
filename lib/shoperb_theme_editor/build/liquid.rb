require 'fileutils'

module Shoperb
  module Theme
    module Editor
      module Build
        class Liquid
          def initialize(section_handle)
            @section_handle = section_handle
          end

          def create_or_update_liquid_file
            sections_dir = File.join(Dir.pwd, "sections")
            FileUtils.mkdir_p(sections_dir)
            liquid_file_path = File.join(sections_dir, "#{@section_handle}.liquid")

            unless File.exist?(liquid_file_path)
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
end