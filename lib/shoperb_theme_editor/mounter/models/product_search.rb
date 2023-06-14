module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ProductSearch
        include Pagy::Backend

        attr_reader :word, :options

        def initialize(word:, **options)
          @word = word
          @options = options
        end

        def paginate(page: 1, per: 12)
          page = 1 if !page || page == 0

          pagy(results, items: per, page: page, count: results.count)
        end

        def performed
          true
        end

        def terms
          word ? word.to_s.split(/[ \+]+/) : ""
        end

        def results
          return Product.none if word.blank?
          return @results if defined?(@results)

          rel = Product
          terms.each do |term|
            rel = rel.where(Sequel.ilike(:name, "%#{term}%")) if term.presence
          end
          @results = rel
        end

        def results_size
          results.size
        end

        def searching?
          word.present?
        end

        def to_curl
          "No request"
        end
      end
    end
  end
end end end
