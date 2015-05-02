require 'rails_helper'

RSpec.describe RoomHelper, type: :helper do

  describe '#my_rooms_class' do

    subject(:my_rooms_class) { helper.my_rooms_class current_type }

    context "when the current type is 'owner'" do
      let(:current_type) { 'owner' }

      it { is_expected.to match /active/ }
    end

    context "when the current type is 'access'" do
      let(:current_type) { 'access' }

      it { is_expected.to eq "" }
    end
  end

  describe '#shared_rooms_class' do

    subject(:shared_rooms_class) { helper.shared_rooms_class current_type }

    context "when the current type is 'owner'" do
      let(:current_type) { 'owner' }

      it { is_expected.to eq "" }
    end

    context "when the current type is 'access'" do
      let(:current_type) { 'access' }

      it { is_expected.to match /active/ }
    end
  end

  describe '#public_rooms_class' do

    subject(:public_rooms_class) { helper.public_rooms_class current_type }

    context "when the current type is 'owner'" do
      let(:current_type) { 'owner' }

      it { is_expected.to eq "" }
    end

    context "when the current type is 'access'" do
      let(:current_type) { 'access' }

      it { is_expected.to eq "" }
    end

    context "when the current type is nil" do
      let(:current_type) { nil }

      it { is_expected.to match /active/ }
    end
  end
end
