require "rails-assets-angular-motion/version"

require "rails-assets-angular"
require "rails-assets-angular-animate"

if defined?(Rails)
  module RailsAssetsAngularMotion
    class Engine < ::Rails::Engine
      # Rails -> use vendor directory.
    end
  end
end
