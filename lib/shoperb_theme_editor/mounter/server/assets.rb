require 'artisans'
require 'fileutils'

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Assets

        def self.asset_wrapper app, root
          compiler = Editor.compiler(root, domain: Editor["oauth-site"], theme: Editor.handle, digests: false)
          artisans_gem_path = Gem.loaded_specs["artisans"].full_gem_path
          theme_path = Dir.getwd
          tmp_dir = "#{theme_path}/tmp"
          asset_path = "#{theme_path}/assets/"
          FileUtils.mkdir_p(tmp_dir)

          app.get "#{root}*" do |path|
            file_path = "#{asset_path}#{path}"
            out_file = nil
            compiler.compile_file(file: file_path).each do |file_name, data|
              out_file = "#{tmp_dir}/#{file_name}"
              File.binwrite(out_file, data)
            end
            send_file out_file
          end
        end

        def self.registered(app)
          asset_wrapper app, "/system/assets/#{Editor["oauth-site"]}/#{Editor.handle}/"
          asset_wrapper app, "/system/assets/"

          app.get "/#{Editor["oauth-site"]}/images/*/*" do |id, filename|
            Model::Image.find(id: id)
            send_file "data/assets/images/#{filename}"
          end

        end

      end
    end
  end
end end end
