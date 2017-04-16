require "rails-assets-textAngular/version"

require "rails-assets-angular"

if defined?(Rails)
  module RailsAssetsTextangular
    class Engine < ::Rails::Engine
      # Rails -> use vendor directory.
    end
  end
end
