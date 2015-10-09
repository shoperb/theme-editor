module Shoperb module Theme module Editor
  class Init

    AVAILABLE_TEMPLATES = ["blank"]

    Editor.autoload_all self, "init"

    def initialize template, handle
      raise Error.new(
        "No such template, possible options are #{AVAILABLE_TEMPLATES.map(&:inspect).to_sentence}"
      ) unless AVAILABLE_TEMPLATES.include?(template)
      Editor["handle"] = handle
      Logger.notify "Copying #{template.inspect} template" do
        FileUtils.cp_r("#{File.expand_path("../init/#{template}", __FILE__)}/.", Utils.base + ".")
      end
    end

  end
end end end
