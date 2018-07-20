module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ProductSearch < Base

        attr_reader :word, :options

        def initialize(word:, **options)
          @word = word
          @options = options
        end

        def paginate(page: 1, per: 12)
          page = 1 if !page || page = 0

          results.page(1).per(per)
        end

        def performed
          true
        end

        def terms
          word ? word.to_s.split(/[ \+]+/) : ""
        end

        def results
          return Product.none if word.blank?

          Product.select do |p|
            terms.any? do |term|
              term.presence && p.name.downcase.include?(term.downcase)
            end
          end
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
