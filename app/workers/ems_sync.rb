class EmsSync
  include Sidekiq::Worker

  def perform
    UserSync.new.sync_all!
  end
end
