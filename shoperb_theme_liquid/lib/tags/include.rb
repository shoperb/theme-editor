module Shoperb module Theme module Liquid module Tag
  class Include < ::Liquid::Include
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
      file_system = context.registers[:file_system] || Liquid::Template.file_system

      # make read_template_file call backwards-compatible.
      case file_system.method(:read_template_file).arity
        when 1
          file_system.read_template_file(context[@template_name])
        when 2
          file_system.read_template_file(context[@template_name], context)
        else
          raise ArgumentError, "file_system.read_template_file expects two parameters: (template_name, context)"
      end
    end
  end
end end end end
