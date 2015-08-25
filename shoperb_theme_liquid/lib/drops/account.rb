module Shoperb module Theme module Liquid module Drop
  class Account < Base

    def shops
      Collection.new(model(Shop).all).tap do |drop|
        drop.context = @context
      end
    end

  end
end end end end
