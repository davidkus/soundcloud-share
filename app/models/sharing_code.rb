class SharingCode < ActiveRecord::Base
  belongs_to :room
  belongs_to :user

  before_save :default_values

  def expired?
    expires && Time.now > expiry_date
  end

  def default_values
    # Generate a random 12-digit alphanumeric string
    self.code = "#{room.id.to_s(36)}#{SecureRandom.random_number(36**12).to_s(36)}"

    self.expiry_date ||= Time.now.advance(hours: +1)
    self.expires ||= false

    true
  end
end
