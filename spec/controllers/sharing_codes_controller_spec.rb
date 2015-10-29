require 'rails_helper'

RSpec.describe SharingCodesController, type: :controller do

  let(:user) { create(:user) }

  let(:room) { create(:room) }
  let(:other_room) { create(:room) }

  before { sign_in user }

  describe 'GET #index' do
    let(:action) { xhr :get, :index, room_id: room.id }

    let(:valid_sharing_code) { create(:sharing_code, expires: false, room: room) }
    let(:expired_sharing_code) { create(:sharing_code, expires: true, expiry_date: Time.now.advance(hours: -1), room: room) }
    let(:other_room_sharing_code) { create(:sharing_code, room: other_room) }

    before { valid_sharing_code }
    before { expired_sharing_code }
    before { other_room_sharing_code }

    context 'when the user does not own the room' do
      before { user.add_role :access, room }

      before { action }

      it { is_expected.to respond_with :redirect }
    end

    context 'when the user does own the room' do
      before { user.add_role :owner, room }

      before { action }

      it { is_expected.to render_template :index }
      it { expect(controller.accessible_codes).to contain_exactly valid_sharing_code }
    end

  end

  describe 'GET #show' do
    let(:action) { xhr :get, :show, room_id: room.id, id: sharing_code.id }

    let(:sharing_code) { create(:sharing_code, room: room) }

    context 'when the user does not own the room' do
      before { user.add_role :access, room }

      before { action }

      it { is_expected.to respond_with :redirect }
    end

    context 'when the user does own the room' do
      before { user.add_role :owner, room }

      before { action }

      it { is_expected.to render_template :show }
      it { expect(controller.sharing_code).to eq sharing_code }
    end
  end

  describe 'GET #new' do
    let(:action) { xhr :get, :new, room_id: room.id }

    context 'when the user does not own the room' do
      before { user.add_role :access, room }

      before { action }

      it { is_expected.to respond_with :redirect }
    end

    context 'when the user does own the room' do
      before { user.add_role :owner, room }

      before { action }

      it { is_expected.to render_template :new }
    end
  end

  describe 'POST #create' do
    let(:action) { xhr :post, :create, room_id: room.id }

    context 'when the user does not own the room' do
      before { user.add_role :access, room }

      it { expect{ action }.not_to change(SharingCode, :count) }
    end

    context 'when the user does own the room' do
      before { user.add_role :owner, room }

      it { expect{ action }.to change(SharingCode, :count).by(+1) }
    end
  end

  describe 'DELETE #destroy' do
    let(:action) { xhr :delete, :destroy, room_id: room.id, id: sharing_code.id }

    let(:sharing_code) { create(:sharing_code, room: room) }

    before { sharing_code }

    context 'when the user does not own the room' do
      before { user.add_role :access, room }

      it { expect{ action }.not_to change(SharingCode, :count) }
    end

    context 'when the user does own the room' do
      before { user.add_role :owner, room }

      it { expect{ action }.to change(SharingCode, :count).by(-1) }
    end
  end

end
