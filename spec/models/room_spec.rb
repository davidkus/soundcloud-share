require 'rails_helper'

RSpec.describe Room, type: :model do

  context 'sets default values' do
    subject(:room) { create(:room) }

    its(:chat_id) { is_expected.not_to be_nil }
    its(:sync_id) { is_expected.not_to be_nil }
    its(:share_id) { is_expected.not_to be_nil }
  end

  describe '#validate' do
    subject(:room) { build(:room, name: name) }

    context 'when the room was not given a name' do
      let(:name) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when the room name is an empty string' do
      let(:name) { "" }

      it { is_expected.not_to be_valid }
    end

    context 'when the room name is a string of whitespace' do
      let(:name) { "  " }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#destroy' do
    let(:room) { build(:room) }

    subject(:destroy_room) { room.destroy }

    it 'is expected to destroy the firebase room' do
      expect(FirebaseService).to receive(:delete_room).with room
      allow(FirebaseService).to receive(:delete_chat)

      destroy_room
    end

    it 'is expected to destroy the firebase chat' do
      expect(FirebaseService).to receive(:delete_chat).with room
      allow(FirebaseService).to receive(:delete_room)

      destroy_room
    end
  end

  describe '#owners' do
    let(:owner) { create(:user) }
    let(:room) { create(:room) }

    subject(:owners) { room.owners }

    context 'when there are no owners' do

      it { is_expected.to be_empty }
    end

    context 'when there is a single owner' do
      before { owner.add_role :owner, room }

      it { is_expected.to contain_exactly owner }
    end
  end
end
