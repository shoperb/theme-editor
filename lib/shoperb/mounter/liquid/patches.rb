module Liquid

  class DelegateDrop < Drop
    def initialize(record)
      @record = record
    end

    def inspect
      "<#{self.class.to_s} #{@record.inspect}>"
    end

    def method_missing name, *args, &block
      @record.send name, *args, &block
    end

    def self.invokable?(method_name)
      # unless @invokable_methods
      #   blacklist = Liquid::Drop.public_instance_methods + [:each]
      #   if include?(Enumerable)
      #     blacklist += Enumerable.public_instance_methods
      #     blacklist -= [:sort, :count, :first, :min, :max, :include?]
      #   end
      #   whitelist = [:to_liquid] + (public_instance_methods - blacklist)
      #   @invokable_methods = Set.new(whitelist.map(&:to_s))
      # end
      # @invokable_methods.include?(method_name.to_s)
      true
    end
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
    rescue Exception => e
      raise e, "'#{e.message}' in #{partial_name}"
    end

  end

end

Liquid::Template.file_system = Liquid::EditorFileSystem.new
