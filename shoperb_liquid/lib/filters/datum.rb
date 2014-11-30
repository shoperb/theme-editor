module Shoperb
  module Liquid
    module Filter
      module Datum

        include ActionView::Helpers::NumberHelper
        include ActionView::Helpers::OutputSafetyHelper
        #prepend ActionView::Helpers::TextHelper

        # either with symbol or code
        def money(money)
          if shop.currency.symbol
            number_to_currency money, :precision => money_precision(money), :unit => shop.currency.symbol, :format => "%u%n", :delimiter => " "
          else
            number_to_currency money, :precision => money_precision(money), :unit => shop.currency.code, :format => "%n %u", :delimiter => " "
          end
        end

        def money_with_cents(money)
          if shop.currency.symbol
            number_to_currency money, :precision => 2, :unit => shop.currency.symbol, :format => "%u%n", :delimiter => " "
          else
            number_to_currency money, :precision => 2, :unit => shop.currency.code, :format => "%n %u", :delimiter => " "
          end
        end

        # with both symbol and code
        def money_with_currency(money)
          if shop.currency.symbol
            value = number_to_currency money, :unit => shop.currency.symbol, :format => "%u%n", :delimiter => " "
          else
            value = number_with_precision money, :precision => 2, :delimiter => " "
          end
          value = value.to_s

          value << " #{shop.currency.code}"
        end

        def money_precision(money)
          fmt = "%05.2f" % money.to_f
          cost_dollars, cost_cents = fmt.split '.'
          if cost_cents.to_i == 0
            0
          else
            2
          end
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
          return unless value

          date = value.kind_of?(String) ? Date.parse(value) : value
          I18n.l(date, :format => formatting)
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

        def random value, limit = nil
          return value unless limit
          value.to_a.sample limit
        end
        deprecate :random

        protected

        def shop
          @context["shop"]
        end

      end
    end
  end
end
