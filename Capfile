# Load DSL and set up stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/eye'
require 'capistrano/sidekiq'
# require 'capistrano/sidekiq/monit' #to require monit tasks # Only for capistrano3

require 'seed-fu/capistrano3'
require 'airbrake/capistrano3'
require 'whenever/capistrano'
# require 'hipchat/capistrano'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

set :eye_application, 'itubridge'
set :eye_config, './config/itubridge.eye'
