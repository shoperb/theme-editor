require 'action_view'
module Shoperb
  module Editor
    module Liquid
      module Filters
        module Data

          include ::ActionView::Helpers::NumberHelper
          include ::ActionView::Helpers::OutputSafetyHelper
          include ::ActionView::Helpers::TextHelper

          def shop
            Shop.instance
          end

          def shop_currency
            shop.try(:currency)
          end

          def currency symbol
            shop_currency.try(symbol)
          end

          # either with symbol or code
          def money(money)
            if currency(:symbol)
              number_to_currency money, :unit => currency(:symbol), :delimiter => " "
            else
              number_to_currency money, :unit => currency(:code), :format => "%n %u", :delimiter => " "
            end
          end

          # with both symbol and code
          def money_with_currency(money)
            if currency(:symbol)
              value = number_to_currency money, :unit => currency(:symbol), :format => "%u%n", :delimiter => " "
            else
              value = number_with_precision money, :precision => 2, :delimiter => " "
            end
            value = value.to_s

            value << " #{currency(:code)}"
          end

          # just numbers
          def money_without_currency(money)
            number_to_currency money, :unit => "", :delimiter => " "
          end

          def without_cents(money)
            money.to_i
          end

          def weight_with_unit(weight, precision = nil)
            return if weight.nil?
            if precision
              weight = "%.#{precision}f" % weight
            end
            "#{weight} #{shop.metric? ? "kg" : "lbs"}" # TODO
          end

          def dimension_with_unit(size)
            "#{size} #{shop.metric? ? "cm" : "inch"}" # TODO
          end

          def upcase(value)
            value.to_s.upcase
          end

          def downcase(value)
            value.to_s.downcase
          end

          def titleize(value)
            value.to_s.titlecase
          end

          def size(value)
            value.to_s.length
          end

          def date(value, formatting)
            value.present? ? Date.parse(value).to_formatted_s(formatting) : nil
          end

          def debug(object)
            safe_join(["<pre>".html_safe, object.inspect, "</pre>".html_safe], "\n")
          end

          def numeric(value)
            value.to_i
          end

          def plus(value, add)
            value.to_i + add
          end

          def minus(value, remove)
            value.to_i - remove
          end

          def times(value, times)
            value.to_i * times
          end

        end

        ::Liquid::Template.register_filter(Data)
      end
    end
  end
end