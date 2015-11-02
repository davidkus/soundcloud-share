class GuestsCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    User.where(guest: true).each do |guest|
      Room.with_role(:owner, guest).destroy_all
      guest.destroy
    end

  end
end
