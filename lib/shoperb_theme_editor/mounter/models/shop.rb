module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Shop < Base

        fields :id, :name, :domain, :email, :time_zone, :unit_system,
          :tax_included, :tax_shipping, :possible_languages, :meta_description,
          :meta_keywords, :meta_title, :reviews,
          :customer_accounts, :account_types

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

      end
    end
  end
end end end
