module Shoperb module Theme module Liquid module Tag
  class Include < ::Liquid::Include

    protected

    def default_file_system(context)
      context.registers[:templates_file_system]
    end

    private

    def load_cached_partial(context)
      cached_partials = context.registers[:cached_partials] || {}
      template_name = context[@template_name]

      if cached = cached_partials[template_name]
        return cached
      end

      source = read_template_from_file_system(context)
      partial = Liquid::Template.parse(source, pass_options)
      cached_partials[template_name] = partial
      context.registers[:cached_partials] = cached_partials
      partial
    end


    def read_template_from_file_system(context)
      file_system = context.registers[:file_system] || default_file_system(context)
      template_path = context[@template_name]
      begin
        read_file_from_file_system(file_system, template_path, context)
      rescue ::Liquid::FileSystemError => e
        file_system = ::Liquid::LocalFileSystem.new(context.registers[:default_partials].to_s, file_system.instance_variable_get("@pattern"))
        begin
          read_file_from_file_system(file_system, template_path, context)
        rescue ::Liquid::FileSystemError => e2
          raise e
        end
      end
    end

    def read_file_from_file_system file_system, template_path, context
      case file_system.method(:read_template_file).arity
        when 1
          file_system.read_template_file(template_path)
        when 2
          file_system.read_template_file(template_path, context)
        else
          raise ArgumentError, "file_system.read_template_file expects two parameters: (template_name, context)"
      end
    end
  end
end end end end
