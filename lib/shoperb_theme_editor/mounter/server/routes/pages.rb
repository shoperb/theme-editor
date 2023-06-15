module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Pages

          class PageFinder
            def self.match str
              !!Model::Page.all.detect { |p| "/#{p.permalink}" == str }
            end
            def self.serve
              ->(id) {
                page = Model::Page.all.detect { |p| p.permalink == id }
                respond (page.template.presence&.to_sym || :page), page: page.to_liquid
              }
            end
          end

          

          def self.registered(app)
            app.get "/pages/:id/?", &PageFinder.serve
            app.get "/:id/?" do
              pass if !PageFinder.match(params[:id])
              PageFinder.serve(params[:id])
            end
          end

        end
      end
    end
  end
end end end
