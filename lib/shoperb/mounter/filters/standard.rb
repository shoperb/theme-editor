module Shoperb
  module Mounter
    module Filter
      module Standard

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
    end
  end
end