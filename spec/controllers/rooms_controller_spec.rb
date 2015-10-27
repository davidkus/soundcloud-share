require 'rails_helper'

RSpec.describe RoomsController, type: :controller do

  let(:user) { create(:user) }
  let(:room) { create(:room, public: public?) }
  let(:public?) { false }

  before { sign_in user }

  before { allow(FirebaseTokenService).to receive(:create_token) }

  describe 'GET #index' do

    let(:action) { get :index, type: room_type }

    let(:owner) { create(:user) }
    let(:public_room) { create(:room, public: true) }
    let(:owner_room) { create(:room) }
    let(:access_room) { create(:room) }

    before { create(:room) }

    before { public_room }
    before { user.add_role :owner, owner_room }
    before { user.add_role :access, access_room }
    before { owner.add_role :owner, public_room }
    before { owner.add_role :owner, access_room }

    before { action }

    context 'when fetching public rooms' do
      let(:room_type) { "public" }

      it { expect(assigns(:rooms)).to contain_exactly public_room }
    end

    context 'when fetching owned rooms' do
      let(:room_type) { "owner" }

      it { expect(assigns(:rooms)).to contain_exactly owner_room }
    end

    context 'when fetching accessible rooms' do
      let(:room_type) { "access" }

      it { expect(assigns(:rooms)).to contain_exactly access_room }
    end
  end

  describe 'GET #show' do

    let(:action) { get :show, id: room.id }

    context 'when the user owns the room' do
      before { user.add_role :owner, room }

      before { action }

      it { is_expected.to render_template :show }
    end

    context 'when the user has access to the room' do
      before { user.add_role :access, room }

      before { action }

      it { is_expected.to render_template :show }
    end

    context 'when the user does not have access to the room' do
      before { action }

      it { is_expected.to respond_with :redirect }
    end

    context 'when the room is public' do
      let(:public?) { true }

      before { action }

      it { is_expected.to render_template :show }
    end
  end

  describe 'GET #new' do

    let(:action) { get :new }

    before { action }

    it { is_expected.to render_template :new }
  end

  describe 'GET #edit' do

    let(:action) { get :edit, id: room.id }

    context 'when the user owns the room' do
      before { user.add_role :owner, room }

      before { action }

      it { is_expected.to render_template :edit }
    end

    context 'when the user has access to the room' do
      before { user.add_role :access, room }

      before { action }

      it { is_expected.to respond_with :redirect }
    end

    context 'when the room is public' do
      let(:public?) { true }

      before { action }

      it { is_expected.to respond_with :redirect }
    end
  end

  describe 'POST #create' do

    let(:action) { post :create, room: { name: name } }

    context 'when the room is not given a name' do
      let(:name) { nil }

      it { action; is_expected.to render_template :new }
      it { expect{ action }.not_to change(Room, :count) }
    end

    context 'when the room is successfully created' do
      let(:name) { "Room Name" }

      it { expect{ action }.to change(Room, :count).by 1 }

      it 'assigns the owner role to the creating user' do
        action

        room = Room.last

        expect(user).to have_role :owner, room
      end
    end

  end

  describe 'PUT #update' do

    let(:action) { put :update, id: room.id, room: { name: 'new_name' } }

    let(:room) { create(:room, name: 'old_name', public: public?) }

    context 'when the user owns the room' do
      before { user.add_role :owner, room }

      it { expect{ action }.to change{ Room.find(room.id).name } }
    end

    context 'when the user has access to the room' do
      before { user.add_role :access, room }

      it { expect{ action }.not_to change{ Room.find(room.id).name } }
    end

    context 'when the room is public' do
      let(:public?) { true }

      before { room }

      it { expect{ action }.not_to change{ Room.find(room.id).name } }
    end
  end

  describe 'DELETE #destroy' do

    let(:action) { delete :destroy, id: room.id }

    before { allow(FirebaseService).to receive(:delete_room) }
    before { allow(FirebaseService).to receive(:delete_chat) }

    before { request.env["HTTP_REFERER"] = rooms_path }

    context 'when the user owns the room' do
      before { user.add_role :owner, room }

      it { expect{ action }.to change(Room, :count).by -1 }
    end

    context 'when the user has access to the room' do
      before { user.add_role :access, room }

      it { expect{ action }.to_not change(Room, :count) }
    end

    context 'when the room is public' do
      let(:public?) { true }

      before { room }

      it { expect{ action }.to_not change(Room, :count) }
    end
  end

end
