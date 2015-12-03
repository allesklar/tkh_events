require "tkh_events/version"
require "tkh_search"
require "tkh_toolbox"
require "tkh_illustrations"
require "prawn"
# require 'prawn-table'

module TkhEvents
  class Engine < ::Rails::Engine
    initializer "TkhEvent precompile hook", :group => :all do |app|
      app.config.assets.precompile += %w( event_public_emails.css events/events.js )
    end
  end
end
