class ExpiredCodesCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    SharingCode.where(["expiry_date < ?", Time.now]).destroy_all(expires: true)
  end
end
