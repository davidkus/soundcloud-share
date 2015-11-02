require 'rails_helper'

RSpec.describe ExpiredCodesCleanupJob, type: :job do

  let(:cleanup_job) { ExpiredCodesCleanupJob.new }

  describe '#perform' do

    subject(:perform) { cleanup_job.perform }

    let(:room) { create(:room) }

    let(:non_expiring_code) { create(:sharing_code, expires: false, room: room) }
    let(:non_expired_code) { create(:sharing_code, expires: true, expiry_date: Time.now.advance(hours: +1), room: room) }
    let(:expired_code) { create(:sharing_code, expires: true, expiry_date: Time.now.advance(hours: -1), room: room) }

    before { non_expiring_code }
    before { non_expired_code }
    before { expired_code }

    it { expect{ perform }.to change(SharingCode, :count).by -1 }

  end

end
