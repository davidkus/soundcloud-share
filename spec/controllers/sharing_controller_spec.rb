require 'rails_helper'

RSpec.describe SharingController, type: :controller do

  let(:owning_user) { create(:user) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #show' do

    let(:action) { get :show, room_id: room.id, id: share_id }

    let(:room) { create(:room, share_link: share_link) }

    before { owning_user.add_role :owner, room }

    before { action }

    context 'when the correct share id is provided' do
      let(:share_id) { room.share_id }

      context 'when the room has the sharing link enabled' do
        let(:share_link) { true }

        it { expect(user).to have_role :access, room }
        it { is_expected.to redirect_to room }
      end

      context 'when the room has sharing link disabled' do
        let(:share_link) { false }

        it { expect(user).not_to have_role :access, room }
        it { is_expected.to redirect_to rooms_path }
      end
    end

    context 'when the incorrect share id is provided' do
      let(:share_id) { "invalid_#{room.share_id}" }
      let(:share_link) { true }

      it { expect(user).not_to have_role :access, room }
      it { is_expected.to redirect_to room }
    end

  end

end
