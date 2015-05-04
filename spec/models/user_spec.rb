require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#validate' do

    subject(:user) { build(:user, username: username) }

    context 'when there is no username provided' do
      let(:username) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when there is already a user with the given username' do
      let(:username) { "username" }

      before { create(:user, username: username) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#guest_user_values' do

    subject(:user) { build(:user, username: username, guest: guest_user?) }

    before { user.save(validate: false) }

    context 'when creating a guest user' do
      let(:guest_user?) { true }
      let(:username) { nil }

      its(:username) { is_expected.not_to be_nil }
    end

    context 'when creating a regular user' do
      let(:guest_user?) { false }
      let(:username) { "example.username" }

      its(:username) { is_expected.to eq username }
    end
  end
end
