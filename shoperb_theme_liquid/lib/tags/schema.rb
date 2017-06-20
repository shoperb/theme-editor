module Shoperb module Theme module Liquid module Tag
  class Schema < ::Liquid::Block

    def render(context)
      context['section'].record.schema = JSON.parse(super) if context['section']
      nil
    end
  end
end end end end
