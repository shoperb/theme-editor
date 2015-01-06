module Shoperb module Theme module Editor
  module Utils
    extend self

    mattr_accessor :path
    self.path = Pathname.new("")

    def rel_path path
      path = Pathname.new(path) unless path.is_a?(Pathname)
      path.relative_path_from(calc_base(path))
    end

    def calc_base path
      path.absolute? ? base : Pathname.new("./")
    end

    def base
      Pathname.new(Pathname.new(""))
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
end end end
