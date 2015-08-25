require "tkh_events/version"
require "tkh_search"
require "tkh_toolbox"
require "tkh_illustrations"

module TkhEvents
  class Engine < ::Rails::Engine
    initializer "TkhEvent precompile hook", :group => :all do |app|
      app.config.assets.precompile += [ 'event_public_emails.css' ]
    end
  end
end
