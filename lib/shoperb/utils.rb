module Shoperb
  module Utils
    extend self

    def mkdir path
      unless Dir.exists?(path)
        Logger.notify "Making directory #{path}" do
          FileUtils.mkdir_p path
        end
      end
    end

    def rel_path path
      pathname = Pathname.new(path)
      pathname.relative_path_from(calc_base(pathname))
    end

    def calc_base path
      path.absolute? ? base : Pathname.new("./")
    end

    def base
      Pathname.new(Dir.pwd)
    end

    def write_file target
      File.open(target, "w+b") { |f| f.write(yield) }
    end
  end
end