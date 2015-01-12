module Shoperb module Theme module Editor
  module Sync
    module Images

      extend self
      mattr_accessor :queue
      self.queue = []

      mattr_accessor :dir
      self.dir = Utils.base + "data" + "assets" + "images"

      def process
        FileUtils.mkdir_p(dir)
        Sync.process Mounter::Model::Image do |image|
          process_sizes(image)
          image
        end
        threaded_download "Downloading images"
      end

      private

      def process_sizes image
        image["sizes"] = image["sizes"].select{|size,url|url}.map do |size, url|
          filename = filename_from_url(url)
          enqueue_download(url, filename)
          [size, filename.relative_path_from(dir).to_s]
        end.compact.to_h
      end

      def filename_from_url url
        dir + "#{Pathname.new(url).basename.to_s.split("?")[0]}"
      end

      def enqueue_download url, filename
        (queue << -> { Utils.write_file(filename) { open(url).read } }) unless File.exists?(filename)
      end

      def threaded_download message
        return unless queue.any?
        Logger.info message
        Logger.notify message do
          current, count = 0, 25
          queue.each_slice(count) do |dls|
            current = current + count
            Logger.info "#{message} #{Sync.counter[current - count, [current, queue.count].min, queue.count]}\r"
            dls.map { |block| Thread.new(&block) }.map(&:join)
          end
        end
      end
    end
  end
end end end
