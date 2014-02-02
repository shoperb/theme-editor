module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class LiquidBase < Base

          attr_accessor :pages

          def initialize(runner)
            self.pages = {}
            super
          end

          def read
            self.fetch

            self.pages
          end

          def pages_to_list
            list = self.pages.values.sort { |a, b| a.fullpath <=> b.fullpath }
            list.sort { |a, b| a.depth <=> b.depth }
          end

          def fetch
            position, last_dirname = nil, nil

            Dir.glob(File.join(self.root_dir, self.finder)).sort.each do |filepath|
              next unless File.directory?(filepath) || filepath =~ /\.(#{Shoperb::Mounter::TEMPLATE_EXTENSIONS.join('|')})$/


              if last_dirname != File.dirname(filepath)
                position, last_dirname = 100, File.dirname(filepath)
              end

              page = self.add(filepath, position: position)

              next if File.directory?(filepath) || page.nil?

              position += 1
            end
          end

          def add(filepath, attributes = {})
            fullpath = self.filepath_to_fullpath(filepath)

            unless self.pages.key?(fullpath)
              attributes[:title]    = File.basename(fullpath).humanize
              attributes[:fullpath] = fullpath

              page = self.model.new(attributes)
              page.mounting_point = self.mounting_point
              page.filepath       = File.expand_path(filepath)

              self.pages[fullpath] = page
            end

            self.pages[fullpath]
          end

          def root_dir
            File.join(self.runner.path, 'app', self.dir)
          end

          def filepath_to_fullpath(filepath)
            fullpath = filepath.gsub(File.join(self.root_dir, '/'), '')

            fullpath.gsub!(/^\.\//, '')

            fullpath.split('.').first
          end

        end
      end
    end
  end
end