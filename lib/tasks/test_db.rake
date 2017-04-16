namespace :test_db do
  desc 'recreate test db'
  task :recreate => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:seed_fu'].invoke
  end
end
