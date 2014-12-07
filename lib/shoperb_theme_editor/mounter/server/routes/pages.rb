module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Pages

          class PageFinder
            def match str
              result = Model::Page.all.detect { |p| "/#{p.permalink}" == str }
              Struct.new(:captures).new([result.permalink]) if !!result
            end
          end

          def self.serve
            ->(id) {
              page = Model::Page.all.detect { |p| p.permalink == id }
              respond page.template.to_sym, page: Drop::Page.new(page)
            }
          end

          def self.registered(app)
            app.get "/pages/:id", &serve
            app.get PageFinder.new, &serve
          end

        end
      end
    end
  end
end end end
