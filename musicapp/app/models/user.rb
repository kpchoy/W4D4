class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: {allow_nil: true, minimum: 6 }

  before_validation :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def password=(password)
    @password = password
    # need to store it to instance variable so can validate
    self.password_digest = BCrypt::Password.create(password)
    nil
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end


end
