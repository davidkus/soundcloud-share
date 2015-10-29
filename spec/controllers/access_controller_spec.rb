require 'rails_helper'

RSpec.describe AccessController, type: :controller do

  let(:owning_user) { create(:user) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #grant_access' do

    let(:action) { get :grant_access, code: code }

    let(:room) { create(:room) }
    let(:sharing_code) { create(:sharing_code, room: room, expires: expires, expiry_date: expiry_date) }

    before { owning_user.add_role :owner, room }
    before { sharing_code }

    before { action }

    context 'when a valid sharing code is provided' do
      let(:code) { sharing_code.code }

      context 'when the code is expired' do
        let(:expires) { true }
        let(:expiry_date) { Time.now.advance(hours: -1) }

        it { is_expected.to redirect_to root_path }
        it { expect(user).not_to have_role :access, room }
      end

      context 'when the code never expires' do
        let(:expires) { false }
        let(:expiry_date) { Time.now.advance(hours: -1) }

        it { is_expected.to redirect_to room }
        it { expect(user).to have_role :access, room }
      end

      context 'when the code has not yet expired' do
        let(:expires) { true }
        let(:expiry_date) { Time.now.advance(hours: +1) }

        it { is_expected.to redirect_to room }
        it { expect(user).to have_role :access, room }
      end

    end

    context 'when an invalid sharing code is provided' do
      let(:code) { '1' }
      let(:expires) { false }
      let(:expiry_date) { Time.now.advance(hours: +1) }

      it { is_expected.to redirect_to root_path }
      it { expect(user).not_to have_role :access, room }
    end

  end

end
