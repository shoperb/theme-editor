$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../..'))

require 'shoperb/editor/logger'
require 'shoperb/editor/version'
require 'shoperb/editor/exceptions'
require 'shoperb/editor/server'
require 'shoperb/mounter'

module Shoperb
  module Editor
    class StandaloneServer < Server

      def initialize(path)
        Shoperb::Editor::Logger.setup(path, false)

        # get the reader
        reader = Shoperb::Mounter::Reader::FileSystem.instance
        reader.run!(path: path)
        reader

        Bundler.require 'misc'

        # run the rack app
        super(reader, disable_listen: true)
      end
    end
  end
end