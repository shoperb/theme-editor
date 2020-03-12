module Shoperb module Theme module Editor
  module Mounter
    module Model
      class BlogPost < Base

        fields :id, :name, :content, :published_at, :permalink, :template,
          :handle, :next_id, :prev_id, :state

        translates :name, :content

        def self.primary_key
          :permalink
        end

        def active?
          published_at.nil? || published_at <= Time.now
        end

        def self.active
          all.select(&:active?)
        end

        def next
          BlogPost.active.detect { |post| post.attributes[:id] == self.next_id }
        end

        def prev
          BlogPost.active.detect { |post| post.attributes[:id] == self.prev_id }
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
