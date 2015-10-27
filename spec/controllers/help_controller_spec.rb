require 'rails_helper'

RSpec.describe HelpController, type: :controller do

  describe 'GET #index' do

    let(:action) { get :index }

    before { action }

    it { is_expected.to render_template(:index) }

  end

end
