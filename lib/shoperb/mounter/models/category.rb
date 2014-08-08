module Shoperb
  module Mounter
    module Model
      class Category < Abstract::Base
        self.finder= :name
        has_many :products, attribute: :name
      end
    end
  end
end

