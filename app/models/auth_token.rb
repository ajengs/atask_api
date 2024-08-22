class AuthToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token, :set_expiration

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def set_expiration
    self.expires_at = 2.weeks.from_now
  end
end
