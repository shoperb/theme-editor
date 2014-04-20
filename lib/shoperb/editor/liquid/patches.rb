module Liquid

  class DelegateDrop < Drop
    def initialize(record)
      @record = record
    end

    def method_missing name, *args, &block
      @record.send name, *args, &block
    end

    def inspect
      "<#{self.class.to_s} #{@record.inspect} >"
    end
  end

  class Template

    # creates a new <tt>Template</tt> object from liquid source code
    def parse_with_utf8(source, context = {})
      if RUBY_VERSION =~ /1\.9/
        source = source.force_encoding('UTF-8') if source.present?
      end
      self.parse_without_utf8(source, context)
    end

    alias_method_chain :parse, :utf8

  end

  module StandardFilters

    private

    def to_number(obj)
      case obj
        when Numeric
          obj
        when String
          (obj.strip =~ /^\d+\.\d+$/) ? obj.to_f : obj.to_i
        when DateTime, Date, Time
          obj.to_time.to_i
        else
          0
      end
    end
  end

  class EditorFileSystem
    def read_template_file(partial_name, context)
      Shoperb::Editor::Models::Fragment.render!(partial_name, context)
    end

  end

end

Liquid::Template.file_system = Liquid::EditorFileSystem.new
