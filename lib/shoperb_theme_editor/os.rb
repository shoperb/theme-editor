module Shoperb module Theme module Editor
  module Os
    REPLACEMENTS = {
      "/dev/null" => {
        /mswin|mingw/ => "NUL:"
      }
    }

    def self.[] key
      REPLACEMENTS[key].detect { |k,v| k =~ RUBY_PLATFORM }[1]
    end
  end
end end end
