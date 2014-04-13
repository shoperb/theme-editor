require 'sinatra'
require 'sinatra/asset_pipeline'
require 'sinatra/flash'
require 'active_support/all'
require 'liquid'
require 'action_view'
require 'action_dispatch'
require 'pry'
require_relative './editor/version'
require_relative './editor/delegate_array'
require_relative './editor/routes'
require_relative './editor/assets'
require_relative './editor/server'
require_relative './editor/models'
require_relative './editor/liquid'

I18n.enforce_available_locales = false

module Shoperb
  module Editor
  end
end
