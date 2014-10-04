module Shoperb
  module Sync
    Pagination = Struct.new("Pagination", :response) do

      def total
        get "x-total"
      end

      def limit
        get "x-limit"
      end

      def offset
        get "x-offset"
      end

      def to
        [total, next_page * limit].min
      end

      def page
        offset / limit + 1
      end

      def next_page
        page + 1
      end

      def present?
        response && total && offset && limit && next_page <= last_page
      end

      def last_page
        (total.to_f / limit).ceil
      end

      def message
        yield(offset + limit, to, total)
      end

      private

      def get name
        response.headers[name].to_i if response.headers.has_key?(name)
      end
    end
  end
end