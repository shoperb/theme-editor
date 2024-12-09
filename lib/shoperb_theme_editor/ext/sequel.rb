require 'sequel'
require 'sequel/adapters/sqlite.rb'

Sequel::Model.require_modification = false

class Sequel::Dataset
    def preload *args, **args2
        self
    end

    def includes *args, **args2
        self
    end

    def reorder(dir)
        order(dir)
    end

    def size(*args)
        count(*args)
    end

    def count1(*args)
        args = ["all"] if args == []
        super(*args)
    end

    def exists?
        exists
    end

    def sorted
        self
    end
end

class Sequel::SQLite::Database
    def execute(sql, opts=OPTS, &block)
    _execute(:select, sql, opts, &block)
    rescue=>e
        return if e.to_s.include?("no such table")
        raise e
    end
end
class Sequel::SQLite::Dataset
    def to_liquid
        to_a.map(&:to_liquid)
    end
end

class Sequel::Model
    def cache_key
        if id.nil?
          "#{model.table_name}/new"
        else
          if respond_to?(:updated_at)
            "#{model.table_name}/#{id}-#{updated_at}"
          else
            "#{model.table_name}/#{id}"
          end
        end
      end
end


module ShoperbLiquid
    class CollectionDrop
        def pagy(collection, vars = {})
            vars[:count] = collection.count
            vars[:limit] ||= pagy_get_limit(vars)
            vars[:page]  ||= pagy_get_page(vars)
            pagy = Pagy.new(**vars)

            [pagy, pagy_get_items(collection, pagy)]
        end
    end
    class ArrayDrop
        def to_ary
            collection
        end
    end
end