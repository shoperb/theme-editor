module Shoperb
  module Mounter
    module Liquid
      class EditorFileSystem

        def read_template_file(partial_name, context)
          Model::Fragment.render!(partial_name, context)
        rescue Exception => e
          raise(e.is_a?(Error) ? e :
            Error.new("'#{e.message}' in _#{partial_name}.liquid").tap do |fe|
              fe.set_backtrace e.backtrace
            end
          )
        end

      end
    end
  end
end