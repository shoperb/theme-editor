module Shoperb module Theme module Editor
  module Mounter
    module Model
      class BlogCategory < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel


        fields :id, :state, :name, :permalink, :description,
         :handle, :translations

        translates :name, :description

        def self.primary_key
          :id
        end

        dataset_module do
          def active
            as_dataset(to_a.select(&:active?))
          end
        end

        has_many :blog_posts

        def self.sorted
          sort_by { |root| root.position }
        end



        def active?
          state == "active"
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end

      end
    end
  end
end end end
