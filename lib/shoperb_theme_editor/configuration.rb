module Shoperb module Theme module Editor
  class Configuration < HashWithIndifferentAccess

    OPTIONS = {
      "oauth-site" => "Your shoperb shop domain",
      "oauth-username" => "Your shoperb shop username",
      "oauth-password" => "Your shoperb shop username",
      "oauth-redirect-uri" => "Url shoperb will redirect to after granting access",
      "verbose" => "Enable verbose mode",
      "port" => "Port you want your local shoperb theme instance to run at",
      "server" => "Shoperb url & protocol for oauth to run against",
    }

    QUESTION = {
      "oauth-site" => "Insert Shoperb domain",
      "oauth-username" => "Insert Shoperb username",
      "oauth-password" => "Insert Shoperb password",
      "handle" => "Insert theme handle"
    }.with_indifferent_access

    HARDCODED = {
      "oauth-client-id" => "jsikb3aoa42w1qkybugvj3t3l6tef2y",
      "oauth-client-secret" => "np47hizd5b9v5749psdyklybt11ygr4",
      "oauth-redirect-uri" => "http://localhost:4000/callback",
      "oauth-username" => nil,
      "oauth-password" => nil,
    }.with_indifferent_access

    DEFAULTS = {
      "oauth-cache" => {}.with_indifferent_access,
      "compile" => {
        js: ["application"],
        css: ["application"]
      }.with_indifferent_access,
      "port" => "4000",
      "verbose" => false,
      "server" => {
        "url" => "shoperb.me",
        "protocol" => "https"
      }
    }.with_indifferent_access

    ASKS = {
      "oauth-password" => -> {
        $stdin.noecho(&:gets).tap do
          puts ""
        end
      }
    }.with_indifferent_access

    attr_accessor :file

    def initialize options={}, *args
      super()

      self.file = Utils.base + ".shoperb"

      begin
        FileUtils.send(args.any? ? :mkdir : :mkdir_p, File.dirname(self.file))
      rescue Errno::EEXIST
        raise Error.new("Folder #{File.dirname(self.file)} already exists")
      end

      merge!(conf)
      merge!(options)
      merge!(HARDCODED)
    end

    def save
      Logger.notify "Saving configuration to #{file.basename}" do
        Utils.write_file(file) { JSON.pretty_generate(self.except(*HARDCODED.keys).as_json) }
      end
    end

    def [] name
      super(name).presence || (self[name] = ask(name))
    end

    def ask name
      default = DEFAULTS[name].presence
      if question = QUESTION[name]
        Logger.info "#{question} #{"(Default is '#{default}') " if default}: "
        # $stdin.gets avoids problem with ARGV & gets
        ASKS.fetch(name, -> { $stdin.gets })[].strip.presence || default
      end || default
    end

    def reset *names
      names.each { |name| self[name] = DEFAULTS[name] }
    end

    def destroy
      Logger.notify "Deleting configuration at #{file}" do
        File.delete(file)
      end if File.exist?(file)
    end

    def conf path=self.file
      File.exist?(path) && (content = File.read(path).presence)? JSON.parse(content) || {} : {}
    end

  end
end end end
