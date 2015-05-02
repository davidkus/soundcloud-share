require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe '#error_messages' do

    subject(:error_messages) { helper.error_messages resource }

    let(:resource) { build(:room, name: room_name) }

    context 'when the resource has no errors' do

      let(:room_name) { "test" }

      before { resource.validate }

      it { is_expected.to eq "" }
    end

    context 'when the resource has errors' do

      let(:room_name) { nil }
      let(:message) { "the error message" }

      before { allow(resource.errors).to receive(:full_messages) { [message] } }

      before { resource.validate }

      it { is_expected.to match /#{message}/ }
    end
  end
end
