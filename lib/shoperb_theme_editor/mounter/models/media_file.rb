module Shoperb module Theme module Editor
  module Mounter
    module Model
      class MediaFile < Base
        fields :id, :filename, :extension, :mime, :url, :image

        def filename
          attributes[:filename]
        end

        def handle
          filename
        end
      end
    end
  end
end end end
