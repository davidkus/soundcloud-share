class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validations
  validates :username, presence: true, uniqueness: true

  # Callbacks
  before_save :guest_user_values, if: :guest

  def gravatar_url
    hash = Digest::MD5.hexdigest(email)
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end

  private

  def guest_user_values
    self.username ||= "guest_#{Time.now.to_i}#{rand(10000)}"
  end
end
