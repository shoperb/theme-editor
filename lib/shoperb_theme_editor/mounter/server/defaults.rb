Sinatra.autoload :Flash, "sinatra/flash"

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Defaults
        module Helpers

          def default_locals locals={}
            set_pagination_defaults

            request.define_singleton_method(:query_parameters) do
              env['rack.request.query_hash']
            end

            ShoperbLiquid.options(self, locals)
          end

          def set_pagination_defaults
            params["pagination"] ||= {}
            params["page"] = params["page"].present? ? params["page"].to_i : 1
            params["pagination"]["size"] ||= (1..25).to_a.sample
            min = params["page"] * params["pagination"]["size"].to_i
            params["pagination"]["total"] ||= (min..min+200).to_a.sample
            params["pagination"]["pages"] ||= (params["pagination"]["total"].to_i / params["pagination"]["size"].to_i)
            params["pagination"]["last"] ||= params["pagination"]["total"].to_i - 1
            params["pagination"]["offset"] ||= ((params["page"].to_i - 1) * params["pagination"]["size"].to_i)
          end

        end

        def self.registered app
          app.helpers Helpers
          app.register Sinatra::Flash
        end
      end
    end
  end
end end end
