require 'rails_helper'

RSpec.describe FirebaseTokenService, type: :service do

  before { allow_message_expectations_on_nil }

  describe '.delete_room' do

    subject(:delete_room) { FirebaseService.delete_room room }

    let(:sync_id) { 123 }
    let(:room) { double(sync_id: sync_id) }

    it "deletes the room with the correct sync id" do
      expect($firebase).to receive(:delete).with("rooms/#{sync_id}")

      delete_room
    end
  end

  describe '.delete_chat' do

    subject(:delete_chat) { FirebaseService.delete_chat chat }

    let(:chat_id) { 123 }
    let(:chat) { double(chat_id: chat_id) }

    it "deletes the chat with the correct chat id" do
      expect($firebase).to receive(:delete).with("chats/#{chat_id}")

      delete_chat
    end
  end
end
