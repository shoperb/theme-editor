module Shoperb
  module Mounter
    class Server
      module Routes
        module Pages

          class PageFinder
            def match str
              result = Model::Page.all.detect { |p| "/#{p.template}" == str }
              Struct.new(:captures).new([result.template]) if !!result
            end
          end

          def self.registered(app)
            app.get PageFinder.new do |template|
              page = Model::Page.all.detect { |p| p.template == template }
              respond :"page.#{template}", page: Drop::Page.new(page)
            end
          end
        end
      end
    end
  end
end