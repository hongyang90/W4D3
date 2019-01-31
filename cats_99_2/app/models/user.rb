# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

  before_validation :ensure_session_token
  validates :user_name, :session_token, uniqueness: true, presence: true
  validates :password_digest, presence: true 
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  def ensure_session_token 
    self.session_token ||= SecureRandom::urlsafe_base64
  end 

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end 

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)

    if user && user.is_password?(password)
      return user 
    else 
      nil 
    end 
  end 

  def password=(password)
    @password = password 

    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
