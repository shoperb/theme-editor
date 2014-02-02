module Shoperb::Editor
  class Server

    # Set the locale from the path if possible or use the default one
    # Examples:
    #   /fr/index   => locale = :fr
    #   /fr/        => locale = :fr
    #   /index      => locale = :en (default one)
    #
    class Locale < Middleware

      def call(env)
        self.set_accessors(env)

        self.set_locale!(env)

        app.call(env)
      end

      protected

      def set_locale!(env)
        locale  = self.mounting_point.default_locale

        if self.path =~ /^(#{self.mounting_point.locales.join('|')})+(\/|$)/
          locale    = $1
          self.path = self.path.gsub($1 + $2, '')
          self.path = 'index' if self.path.blank?
        end

        Shoperb::Mounter.locale = locale
        ::I18n.locale = locale

        self.log "Detecting locale #{locale.upcase}"

        env['editor.locale'] = locale
        env['editor.path']   = self.path
      end

    end
  end
end