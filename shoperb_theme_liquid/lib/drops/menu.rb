module Shoperb module Theme module Liquid module Drop
  class Menu < Base

    def id
      record.id
    end

    def name
      record.name
    end

    def handle
      record.handle
    end

    def links
      Collection.new(record.links).tap do |drop|
        drop.context = @context
      end
    end

    def root_links
      Collection.new(record.links.detect { |link| link.parent_id == nil }).tap do |drop|
        drop.context = @context
      end
    end

  end
end end end end
