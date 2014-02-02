require 'listen'

module Shoperb::Editor
  class Listen

    attr_accessor :reader

    def self.instance
      @@instance = new
    end

    def start(reader)
      # if $parent_pid && $parent_pid == Process.pid
      #   puts "bypassing Listen in the parent process"
      #   return false
      # end

      puts "Listening here: #{Process.pid}"

      self.reader = reader

      self.definitions.each do |definition|
        self.apply(definition)
      end
    end

    def definitions
      [
        ['config', /\.yml/, [:theme, :shop]],
        ['app/layouts', /\.liquid/, [:layouts]],
        ['app/templates', /\.liquid/, [:pages]],
        ['app/config', /\.yml/, :translations]
      ]
    end

    protected

    def apply(definition)
      reloader = Proc.new do |modified, added, removed|
        resources = [*definition.last]
        names     = resources.map { |n| "\"#{n}\"" }.join(', ')

        Shoperb::Editor::Logger.info "* Reloaded #{names} at #{Time.now}"

        begin
          reader.reload(resources)
        rescue Exception => e
          Shoperb::Editor::MounterException.new('Unable to reload', e)
        end
      end

      filter  = definition[1]
      path    = File.join(self.reader.mounting_point.path, definition.first)
      path    = File.expand_path(path)

      listener = ::Listen.to(path, only: filter, &reloader)

      # non blocking listener
      listener.start #(false)
    end

  end

end