namespace :ems_export do

  desc "run sync scripts manually without workers"
  task :sync => :environment do
    UserSync.new.sync_all!
  end
end
