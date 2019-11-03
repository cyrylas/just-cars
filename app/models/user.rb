# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, length: { minimum: 1, maximum: 100 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  def active?
    is_active
  end
end
