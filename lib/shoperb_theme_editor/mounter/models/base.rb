module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Base

        module SequelClass
          def fields(*args)
            @fields_list ||= []
            @fields_list  |= args
            c_fields(*args, cast: String)
          end

          def c_fields(*args, **opts)
            @fields_casted ||= {}
            args.each do |field|
              @fields_casted[field] = opts
              case opts[:cast].to_s
              when JSON.to_s, Array.to_s
                define_method field do
                  JSON.parse(@values[field.to_sym]) if @values[field.to_sym]
                end
              when BigDecimal.to_s
                define_method field do
                  BigDecimal(@values[field.to_sym]) if @values[field.to_sym]
                end
              when Integer.to_s
                define_method field do
                  Integer(@values[field.to_sym]) if @values[field.to_sym]
                end
              when TrueClass.to_s
                define_method field do
                  @values[field.to_sym] == "1" || @values[field.to_sym] == "T"
                end
                define_method "#{field}?" do
                  public_send field
                end
              end
            end
          end

          def belongs_to(*args, **args2)
            many_to_one(*args, **args2)
          end
          def has_many(*args, **args2)
            one_to_many(*args, **args2)
            args.each do |meth|
              define_method meth do
                public_send("#{meth}_dataset")
              end
            end
          end

          def find_by(*args, **args2)
            find(**args2)
          end

          def includes(*args)
            self
          end

          def sum(*args)
            super || 0
          end
          
          def size
            count
          end
          

          def translates *args
            c_fields :translations, cast: JSON

            args.each do |arg|
              define_method arg do |*_|
                ((translations || {})[Translations.locale] || {}).fetch(arg.to_s, @values[arg])
              end
            end
          end

          def assign(records)
            db = ::Sequel::Model.db
            create_table

            data = records.map do |record|
              @fields_casted.each_with_object([]) do |(field, opts), arr|
                if opts[:cast].to_s == "TrueClass"
                  record[field.to_s] = record[field.to_s] ? '1' : '0'
                end

                if db.schema(table_name).to_h[field][:db_type] == "TEXT" && record[field.to_s] && !record[field.to_s].is_a?(String)
                  arr.push(JSON.dump( record[field.to_s] ))
                else
                  arr.push(         ( record[field.to_s] ))
                end
              end
            end
            db[table_name].import(@fields_casted.keys,  data)
          rescue=>e
            binding.pry
          end

          def create_table
            fields = @fields_casted
            db = ::Sequel::Model.db
            db.create_table(table_name) do
              fields.each do |field, opts|
                case field.to_s
                when "id"
                  primary_key :id
                when /_id$/, "lft", "rgt", "level"
                  Integer field
                else
                  case opts[:cast].to_s
                  when BigDecimal.to_s
                    BigDecimal field
                  when Integer.to_s
                    Integer field
                  when TrueClass
                    Boolean field
                  else
                    text field
                  end
                end
              end
            end if db["SELECT count(*) a FROM sqlite_master WHERE type='table' AND name='#{table_name}'"].first[:a] == 0
          end

        end


        module Sequel
          extend ActiveSupport::Concern

          included do
            dataset_module do
              def none
                where(Sequel.lit("1=1"))
              end

              def as_dataset(relation)
                filter(id: relation.map(&:id))
              end
            end

            c_fields :custom_field_values, cast: JSON
          end

          def to_liquid context=nil
            if klass = (ShoperbLiquid.const_get("#{self.class.to_s.demodulize}Drop"))
              klass.new(self).tap do |drop|
                drop.context = context if context
              end
            end
          end

          def attributes
            @values
          end
  
          def id
            self.class.primary_key.to_s == "id" ? super : send(self.class.primary_key)
          end

          def as_dataset(relation)
            self.class.as_dataset(relation)
          end

          def to_param
            respond_to?(:permalink) ? permalink : id
          end
        end

        class << self
          
          def save
            Cart.create_table
            CartItem.create_table
          end

        end
      end
    end
  end
end end end
