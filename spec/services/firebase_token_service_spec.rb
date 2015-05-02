require 'rails_helper'

RSpec.describe FirebaseTokenService, type: :service do

  before { allow_message_expectations_on_nil }

  describe '.create_token' do

    subject(:create_token) { FirebaseTokenService.create_token payload }

    let(:payload) { { data: "value" } }

    it "calls through to the firebase token generator" do
      expect($generator).to receive(:create_token).with(payload)

      create_token
    end
  end
end
