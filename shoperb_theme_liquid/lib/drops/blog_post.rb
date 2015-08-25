module Shoperb module Theme module Liquid module Drop
  class BlogPost < Base

    def id
      record.id
    end

    def name
      record.name
    end

    def handle
      record.handle
    end

    def content
      record.content
    end

    def published_at
      record.published_at
    end

    def url
      "#{default_url_language}/blog/#{id}"
    end

  end
end end end end
