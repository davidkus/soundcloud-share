require 'rails_helper'

RSpec.describe RoomsController, type: :controller do

  let(:user) { create(:user) }
  let(:room) { create(:room, public: public?) }
  let(:public?) { false }

  before { sign_in user }

  before { allow(FirebaseTokenService).to receive(:create_token) }

  describe 'GET #index' do

    let(:action) { get :index }

    before { action }

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

  end

  describe 'POST #edit' do

    let(:action) { get :edit }
  end

  describe 'POST #create' do

    let(:action) { post :create }

  end

  describe 'PUT #update' do

    let(:action) { put :update }

  end

  describe 'DELETE #destroy' do

    let(:action) { delete :destroy }
  end

end
