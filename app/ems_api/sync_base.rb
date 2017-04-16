class SyncBase
  attr_writer :logger

  protected

  def logger
    @logger ||= Logger.new(STDOUT)
  end

end
