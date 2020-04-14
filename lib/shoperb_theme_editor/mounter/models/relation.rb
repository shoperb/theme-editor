require 'pagy'

module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Relation
        include Pagy::Backend
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

        def paginate(page, per_page)
          # copy of pagy/extras/array
          vars = {
            count: collection.size,
            page:  page,
            items: per_page
          }
          pagy = Pagy.new(vars)
          return pagy, self.class.new(collection[pagy.offset, pagy.items], @klass)
        end

        protected


        def with_current_collection
          old_data = klass.instance_variable_get("@records")
          klass.instance_variable_set("@records", collection)
          res = yield
          klass.instance_variable_set("@records", old_data)
          res
        end
      end
    end
  end
end end end
