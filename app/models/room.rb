class Room < ActiveRecord::Base
  resourcify

  # Callbacks
  after_destroy :delete_firebase_entries
  before_save :default_values

  # Validations
  validates :name, presence: true

  def owners
    User.with_role :owner, self
  end

  private

  def delete_firebase_entries
    FirebaseService.delete_room self
    FirebaseService.delete_chat self
  end

  def default_values
    self.sync_id  ||= SecureRandom.uuid
    self.chat_id  ||= SecureRandom.uuid

    # Generate a random 12-digit alphanumeric string
    self.share_id ||= SecureRandom.random_number(36**12).to_s(36)
  end
end
