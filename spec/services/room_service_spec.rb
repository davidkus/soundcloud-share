require 'rails_helper'

RSpec.describe RoomService, type: :service do

  describe '.tansfer_permissions' do

    subject { target_user }

    let(:original_user) { create(:user) }
    let(:target_user) { create(:user) }
    let(:owner_room) { create(:room) }
    let(:access_room) { create(:room) }

    let(:target_owner_room) { create(:room) }
    let(:target_access_room) { create(:room) }

    let(:other_room) { create(:room) }

    # Set Up original permissions
    before { original_user.add_role :owner, owner_room }
    before { original_user.add_role :access, access_room }
    before { target_user.add_role :owner, target_owner_room }
    before { target_user.add_role :access, target_access_room }

    before { RoomService.transfer_permissions original_user, target_user }

    it { is_expected.to have_role :owner, target_owner_room }
    it { is_expected.to have_role :access, target_access_room }

    it { is_expected.to have_role :owner, owner_room }
    it { is_expected.not_to have_role :access, owner_room }

    it { is_expected.to have_role :access, access_room }
    it { is_expected.not_to have_role :owner, access_room }

    it { is_expected.not_to have_role :owner, other_room }
    it { is_expected.not_to have_role :access, other_room }
  end
end
