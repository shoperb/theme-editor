module Shoperb module Theme module Editor
  module Mounter
    module Model
      class BlogPost < Base

        fields :id, :name, :content, :published_at, :slug, :permalink, :template, :handle, :next_id, :prev_id

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
          BlogPost.all.detect { |post| post.attributes[:id] == self.next_id }
        end

        def prev
          BlogPost.all.detect { |post| post.attributes[:id] == self.prev_id }
        end

      end
    end
  end
end end end
