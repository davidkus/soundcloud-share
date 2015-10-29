class Room < ActiveRecord::Base
  resourcify

  # Callbacks
  after_destroy :delete_firebase_entries
  before_save :default_values

  # Validations
  validates :name, presence: true

  has_many :sharing_codes

  def owners
    User.with_role :owner, self
  end

  def users_with_access
    User.with_role :access, self
  end

  def identicon_hash
    Digest::MD5.hexdigest("#{id} - #{name}")
  end

  private

  def delete_firebase_entries
    FirebaseService.delete_room self
    FirebaseService.delete_chat self
  end

  def default_values
    self.sync_id  ||= SecureRandom.uuid
    self.chat_id  ||= SecureRandom.uuid
  end
end
