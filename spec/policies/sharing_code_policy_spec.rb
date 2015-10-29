require 'spec_helper'

RSpec.describe SharingCodePolicy, type: :policy do

  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:sharing_code) { create(:sharing_code, room: room) }

  subject { SharingCodePolicy.new user, sharing_code }

  context 'for the owner of the room' do

    before { user.add_role :owner, room }

    it { is_expected.to permit_auth :show }
    it { is_expected.to permit_auth :new }
    it { is_expected.to permit_auth :create }
    it { is_expected.to permit_auth :destroy }
  end

  context 'for a user with access' do

    before { user.add_role :access, room }

    it { is_expected.not_to permit_auth :show }
    it { is_expected.not_to permit_auth :new }
    it { is_expected.not_to permit_auth :create }
    it { is_expected.not_to permit_auth :destroy }
  end

  context 'for an unauthorized user' do

    it { is_expected.not_to permit_auth :show }
    it { is_expected.not_to permit_auth :new }
    it { is_expected.not_to permit_auth :create }
    it { is_expected.not_to permit_auth :destroy }
  end

end
