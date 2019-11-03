# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'validate name' do
    specify 'too short' do
      user.name = ''
      expect(user).not_to be_valid
    end
    specify 'too long' do
      user.name = 'a' * 101
      expect(user).not_to be_valid
    end
  end

  describe 'validate email' do
    specify 'too short' do
      user.email = ''
      expect(user).not_to be_valid
    end
    specify 'invalid format' do
      user.email = 'mail_mail'
      expect(user).not_to be_valid
    end
    specify 'too long' do
      user.email = 'a' * 201
      expect(user).not_to be_valid
    end
  end

  describe 'validate password' do
    specify 'too short' do
      user.password = 'a' * 7
      expect(user).not_to be_valid
    end
  end
end
