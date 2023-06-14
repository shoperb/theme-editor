module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Shop < Sequel::Model(:shop)
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :domain, :email, :time_zone, :unit_system,
          :tax_included, :tax_shipping, :meta_description,
          :meta_keywords, :meta_title, :reviews,
          :customer_accounts, :account_types
        c_fields :possible_languages, cast: Array
        c_fields :language_id,        cast: Integer
        c_fields :currency_id,        cast: Integer

        def self.primary_key
          :domain
        end

        def self.instance
          all.first
        end

        def metric?
          unit_system == "METRIC"
        end

        def imperial?
          unit_system == "IMPERIAL"
        end

        def external_hostname
          domain
        end

        def address
          Model::Address.all.detect { |address| address.owner_type == "Shop" && address.owner_id == attributes[:id] }
        end

        def grouped_integrations
          { head: [], start_body: [], end_body: [] }.stringify_keys
        end

        def all_languages
          ([language.code] + possible_languages).compact.uniq
        end

        belongs_to :currency
        belongs_to :language

        def language_code
          language.code
        end

      end
    end
  end
end end end
