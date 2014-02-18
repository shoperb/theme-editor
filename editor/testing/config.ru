require 'shoperb/editor/standalone_server'
require 'sass'
run Shoperb::Editor::StandaloneServer.new(File.expand_path('.'))