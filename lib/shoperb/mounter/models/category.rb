module Shoperb
  module Mounter
    module Models
      class Category < Base
        self.finder= :name
        has_many :products, attribute: :name
      end
    end
  end
end

