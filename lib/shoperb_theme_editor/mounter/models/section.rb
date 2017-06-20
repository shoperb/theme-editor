module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Section < Base
        fields :id, :handle, :schema

        def to_liquid context=nil
          Liquid::Drop::Section.new(self).tap do |drop|
            drop.context = context if context
          end
        end

        # fetch default values from schema
        def settings
          return {} unless schema
          @_settings ||= fetch_settings(schema)
        end

        private

        def fetch_settings(schema, res = {})
          schema['settings'].each do |setting_hash|
            if setting_hash['type'] == 'category'
              res.merge!(fetch_settings(setting_hash))
            else
              res[setting_hash['handle']] = setting_hash['default']
            end
          end

          res
        end

      end
    end
  end
end end end
