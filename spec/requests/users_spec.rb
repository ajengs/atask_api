require 'rails_helper'

RSpec.describe "/users", type: :request do
  before do
    login_user
  end

  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:user, name: nil)
  }

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get users_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get user_url(user), headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url,
            params: { user: valid_attributes },
            headers: @valid_headers,
            as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post users_url,
          params: { user: valid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to be_present
        expect(json_response['name']).to eq(valid_attributes[:name])
        expect(json_response['email']).to eq(valid_attributes[:email])
        expect(json_response['password_digest']).to be_nil
        expect(json_response['wallet']).to be_present
        expect(json_response['wallet']['balance']).to eq("0.0")
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url,
            params: { user: invalid_attributes },
            as: :json
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post users_url,
          params: { user: invalid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        FactoryBot.attributes_for(:user, name: "New Name")
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: { user: new_attributes },
          headers: @valid_headers,
          as: :json
        user.reload
        expect(user.name).to eq("New Name")
      end

      it "renders a JSON response with the user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: { user: new_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: { user: invalid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
