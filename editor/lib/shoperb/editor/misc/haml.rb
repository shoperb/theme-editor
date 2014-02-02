module Haml::Filters

  remove_filter("Markdown") #remove the existing Markdown filter

  module Markdown # the contents of this are as before, but without the lazy_require call

    include Haml::Filters::Base

    def render text
      Shoperb::Editor::Markdown.render text
    end

  end

end