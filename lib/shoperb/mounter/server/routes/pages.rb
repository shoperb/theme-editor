module Shoperb
  module Mounter
    class Server
      module Routes
        module Pages

          def self.registered(app)

            Model::Page.all.each do |page|
              app.get "/#{page.template}" do
                respond :"page.#{page.template}", page: page
              end
            end

          end
        end
      end
    end
  end
end