module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class ShopReader < SingletonBase

          def read
            super do |shop|
              Time.zone = ActiveSupport::TimeZone.new(shop.timezone || 'UTC')
            end
          end

        end

      end
    end
  end
end