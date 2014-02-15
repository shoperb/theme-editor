module Shoperb
  module Mounter
    module Reader
     module FileSystem

       # Build a singleton instance of the Runner class.
       #
       # @return [ Object ] A singleton instance of the Runner class
       #
       def self.instance
         @@instance ||= Runner.new(:file_system)
       end

       class Runner < Shoperb::Mounter::Reader::Runner

         attr_accessor :path

         # Compass is required
         def prepare
           self.path = parameters.delete(:path)

           if self.path.blank? || !File.exists?(self.path)
             raise Shoperb::Mounter::ReaderException.new('path is required and must exist')
           end

           Shoperb::Mounter::Extensions::Compass.configure(self.path)
         end

         # Ordered list of atomic readers
         #
         # @return [ Array ] List of classes
         #
         def readers
           FileSystem::SingletonBase.subclasses +
             FileSystem::PluralBase.subclasses +
             FileSystem::LiquidBase.subclasses
         end

       end

      end
    end
  end
end