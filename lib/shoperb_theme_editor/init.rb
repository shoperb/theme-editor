module Shoperb module Theme module Editor
  class Init

    Editor.autoload_all self, "init"

    def self.available_templates
      Dir.glob("#{File.expand_path("../init/*", __FILE__)}").map(&Pathname.method(:new)).map(&:basename).map(&:to_s)
    end

    def initialize template, handle
      raise Error.new(
        "No such template, possible options are #{self.class.available_templates.map(&:inspect).to_sentence}"
      ) unless self.class.available_templates.include?(template)
      Editor["handle"] = handle
      Logger.notify "Copying #{template.inspect} template" do
        FileUtils.cp_r("#{File.expand_path("../init/#{template}", __FILE__)}/.", Utils.base + ".")
      end
    end

  end
end end end
