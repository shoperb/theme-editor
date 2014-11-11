module Shoperb
  module Utils
    extend self

    mattr_accessor :path do
      Dir.pwd
    end

    def mkdir path
      FileUtils.mkdir_p path
    end

    def rel_path path
      path = Pathname.new(path) unless path.is_a?(Pathname)
      path.relative_path_from(calc_base(path))
    end

    def calc_base path
      path.absolute? ? base : Pathname.new("./")
    end

    def base
      Pathname.new(path)
    end

    def write_file target
      File.open(target, "w+b") { |f| f.write(yield) }
    end

    def mk_tempfile content, *names
      Tempfile.new(names).tap do |file|
        file.write(content)
        file.flush
        file.open
      end
    end

    def rm_tempfile file
      if file && File.exists?(file)
        file.close
        file.unlink
      end
    end
  end
end
