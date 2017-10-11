module Shoperb module Theme module Editor
  module Sync
    Pagination = Struct.new("Pagination", :response) do

      def total
        pagination["total"]
      end

      def limit
        pagination["limit"]
      end

      def offset
        pagination["offset"]
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
        response && header && total && offset && limit && next_page <= last_page
      end

      def last_page
        (total.to_f / limit).ceil
      end

      def message
        yield(offset + limit, to, total)
      end

      private

      def pagination
        JSON.parse(header)
      end

      def header
        response.headers["x-pagination"]
      end
    end
  end
end end end
