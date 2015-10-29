require 'rails_helper'

RSpec.describe SharingCode, type: :model do

  let(:sharing_code) { build(:sharing_code, expires: expires, expiry_date: expiry_date) }

  describe '#expired?' do

    subject(:expired?) { sharing_code.expired? }

    context 'when the sharing code does not expire' do
      let(:expires) { false }

      context 'when passed the expiry time' do
        let(:expiry_date) { Time.now.advance(hours: -1) }

        it { is_expected.to be false }
      end

      context 'when the expiry time has not passed' do
        let(:expiry_date) { Time.now.advance(hours: +1) }

        it { is_expected.to be false }
      end
    end

    context 'when the sharing code expires' do
      let(:expires) { true }

      context 'when passed the expiry time' do
        let(:expiry_date) { Time.now.advance(hours: -1) }

        it { is_expected.to be true }
      end

      context 'when the expiry time has not passed' do
        let(:expiry_date) { Time.now.advance(hours: +1) }

        it { is_expected.to be false }
      end
    end
  end
end
