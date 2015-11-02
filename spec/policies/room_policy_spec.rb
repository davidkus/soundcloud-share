require 'spec_helper'

RSpec.describe RoomPolicy, type: :policy do

  let(:user) { create(:user) }
  let(:room) { create(:room, public: public) }
  let(:public) { false }

  subject { RoomPolicy.new user, room }

  context 'for a guest user' do
    let(:user) { create(:user, guest: true) }

    it { is_expected.not_to permit_auth :create_public }
  end

  context 'for a registered user' do
    let(:user) { create(:user, guest: false) }

    it { is_expected.to permit_auth :create_public }
  end

  context 'for any user' do

    it { is_expected.to permit_auth :index }
    it { is_expected.to permit_auth :new }
    it { is_expected.to permit_auth :create }
  end

  context 'for the owner' do

    before { user.add_role :owner, room }

    context 'of a private room' do
      let(:public) { false }

      it { is_expected.to permit_auth :show }
      it { is_expected.to permit_auth :edit }
      it { is_expected.to permit_auth :update }
      it { is_expected.to permit_auth :destroy }
    end

    context 'of a public room' do
      let(:public) { true }

      it { is_expected.to permit_auth :show }
      it { is_expected.to permit_auth :edit }
      it { is_expected.to permit_auth :update }
      it { is_expected.to permit_auth :destroy }
    end
  end

  context 'for a user with access' do

    before { user.add_role :access, room }

    context 'to a private room' do
      let(:public) { false }

      it { is_expected.to permit_auth :show }
      it { is_expected.not_to permit_auth :edit }
      it { is_expected.not_to permit_auth :update }
      it { is_expected.not_to permit_auth :destroy }
    end

    context 'to a public room' do
      let(:public) { true }

      it { is_expected.to permit_auth :show }
      it { is_expected.not_to permit_auth :edit }
      it { is_expected.not_to permit_auth :update }
      it { is_expected.not_to permit_auth :destroy }
    end
  end

  context 'for an unauthorized user' do

    context 'to a private room' do
      let(:public) { false }

      it { is_expected.not_to permit_auth :show }
      it { is_expected.not_to permit_auth :edit }
      it { is_expected.not_to permit_auth :update }
      it { is_expected.not_to permit_auth :destroy }
    end

    context 'to a public room' do
      let(:public) { true }

      it { is_expected.to permit_auth :show }
      it { is_expected.not_to permit_auth :edit }
      it { is_expected.not_to permit_auth :update }
      it { is_expected.not_to permit_auth :destroy }
    end
  end

end
