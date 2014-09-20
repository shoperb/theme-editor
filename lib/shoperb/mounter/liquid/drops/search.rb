module Shoperb
  module Mounter
    module Liquid
      module Drop
        class Search < DelegateDrop

          def initialize(word = "")
            @record = Model::Search.instance
          end

          def paginate(page = 1, search_size = 25)
            self
          end

          def results
            res = @record.try(:results) || []
            Mounter::Model::Product.all.select { |p| res.include?(p.name) }
          end

          alias_method :collection, :results
          delegate :any?, to: :results
          delegate :each, to: :results
          delegate :map, to: :results

          def inspect
            to_s
          end

        end
      end
    end
  end
end