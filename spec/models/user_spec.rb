# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(described_class.devise_modules).to include(:database_authenticatable)
    end

    it "includes omniauthable" do
      expect(described_class.devise_modules).to include(:omniauthable)
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456",
        info: {
          email: "test@example.com",
          name: "Test User",
          image: "https://example.com/avatar.png"
        }
      )
    end

    context "when user does not exist" do
      it "creates a new user" do
        expect { described_class.from_omniauth(auth) }.to change(described_class, :count).by(1)
      end

      it "sets the correct attributes" do
        user = described_class.from_omniauth(auth)

        expect(user.email).to eq("test@example.com")
        expect(user.name).to eq("Test User")
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456")
      end
    end

    context "when user already exists" do
      before do
        create(:user, provider: "google_oauth2", uid: "123456", email: "existing@example.com")
      end

      it "returns the existing user" do
        expect { described_class.from_omniauth(auth) }.not_to change(described_class, :count)
      end
    end
  end
end
