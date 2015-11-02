require 'rails_helper'

RSpec.describe GuestsCleanupJob, type: :job do

  let(:cleanup_job) { GuestsCleanupJob.new }

  describe '#perform' do

    subject(:perform) { cleanup_job.perform }

    let(:guest_room) { create(:room) }
    let(:user_room) { create(:room) }
    let(:guest_user) { create(:user, guest: true) }
    let(:user) { create(:user, guest: false) }

    before { guest_user.add_role(:owner, guest_room) }
    before { user.add_role(:owner, user) }

    before { allow(FirebaseService).to receive(:delete_room) }
    before { allow(FirebaseService).to receive(:delete_chat) }

    it { expect{ perform }.to change(Room, :count).by -1 }
    it { expect{ perform }.to change(User, :count).by -1 }

  end

end
