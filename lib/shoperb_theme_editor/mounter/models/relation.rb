module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Relation
        attr_reader :collection, :klass

        def self.build(collection, klass)
          # Create relation<klass> dynamically.
          # Creating class itself right away (instead of just
          # assigning singleton methods) is far more fast in a long term
          return collection if collection.is_a?(Relation)

          relation_subclass = begin
            self.const_get("Relation_#{klass.name.demodulize}")
          rescue StandardError => e
            self.const_set("Relation_#{klass.name.demodulize}", Class.new(self) do
              # delegating klass scopes to self
              (klass.singleton_methods - [:method_missing]).each do |method|
                next if Relation.instance_methods.include?(method)
                define_method method do |*args, &block|
                  with_current_collection do
                    klass.send(method, *args, &block)
                  end
                end
              end
            end)
          end

          relation_subclass.new(collection, klass)
        end

        def initialize(collection, klass)
          @collection = collection
          @klass = klass || collection[0].try(:class)
          @per = 20
        end

        delegate :each, :-, :+, :[], :|, :&, :to_yaml, :to_liquid, :map, to: :collection

        # delegating regular enumerable methods
        # to collection
        (Enumerable.instance_methods + [:last] - [:map]).each do |method|
          define_method method do |*args, &block|
            res = collection.send(method, *args, &block)
            if res.is_a?(Array) && (!res[0] || res[0].is_a?(Model::Base))
              res.to_relation(klass)
            else
              res
            end
          end
        end

        def to_ary
          collection
        end

        def to_a
          collection
        end

        # simulate some activerecrod
        # aggregation functions
        # in case if invoked inside drops
        def sum(key = nil, &block)
          if key
            collection.sum(&key.to_sym)
          elsif block_given?
            collection.sum(&block)
          end
        end

        def minimum(key)
          collection.min_by(&key.to_sym)
        end

        def maximum(key)
          collection.max_by(&key.to_sym)
        end

        def pluck(key)
          collection.map(&key.to_sym)
        end

        def exists?
          collection.present?
        end

        def size
          collection.count
        end

        def ids(key)
          pluck(:id)
        end

        def reorder(*_)
          self
        end

        def includes(*_)
          self
        end

        def joins(*_)
          self
        end

        def left_joins(*_)
          self
        end

        def references(*_)
          self
        end

        def preload(*_)
          self
        end

        # super simplified pagination
        def per(per_page)
          @per = per_page
          # restore collection when 'per' is changed
          @collection = @original_collection if @original_collection
          paginate
          self
        end

        def page(page_number = 1)
          page_number = 1 if !page_number || page_number == 0
          @page = page_number
          paginate
          self
        end

        def num_pages
          return 0 unless @per && @page
          (@original_collection.size * 1.0 / @per).ceil
        end

        def total_count
          return count unless @per && @page
          @original_collection.count
        end

        def limit_value
          @per
        end

        def total_pages
          num_pages
        end

        def offset_value
          return 0 unless @per && @page
          (@page - 1) * @per
        end

        def offset
          offset_value
        end

        protected

        def paginate
          return unless @per && @page
          @original_collection = @collection
          @collection = @collection[(@page - 1) * @per, (@page - 1) * @per + @per - 1]
        end

        def with_current_collection
          old_data = klass.instance_variable_get("@records")
          #old_all = klass.instance_variable_get("@all")
          klass.instance_variable_set("@records", collection)
          #klass.instance_variable_set("@all", nil)
          res = yield
          klass.instance_variable_set("@records", old_data)
          #klass.instance_variable_set("@all", old_all)
          res
        end
      end
    end
  end
end end end
