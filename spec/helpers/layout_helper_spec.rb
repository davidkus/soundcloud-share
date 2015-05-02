require 'rails_helper'

RSpec.describe LayoutHelper, type: :helper do

  describe '#link_active' do

    before { allow(controller).to receive(:controller_name).and_return "some_controller" }

    subject { helper.link_active(controller_name) }

    context 'when the controller name matches the link' do
      let(:controller_name) { "some_controller" }

      it { is_expected.to eq "active" }
    end

    context 'when the controller name does not match the link' do
      let(:controller_name) { "some_other_controller" }

      it { is_expected.to be_nil }
    end
  end
end
