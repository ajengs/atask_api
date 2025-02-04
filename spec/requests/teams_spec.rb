require 'rails_helper'

RSpec.describe "/teams", type: :request do
  let(:valid_attributes) {
    FactoryBot.attributes_for(:team)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:team, name: nil)
  }

  before do
    login_user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Team.create! valid_attributes
      get teams_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      team = Team.create! valid_attributes
      get team_url(team), headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Team" do
        expect {
          post teams_url,
            params: { team: valid_attributes },
            headers: @valid_headers,
            as: :json
        }.to change(Team, :count).by(1)
      end

      it "renders a JSON response with the new team" do
        post teams_url,
          params: { team: valid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to be_present
        expect(json_response['name']).to eq(valid_attributes[:name])
        expect(json_response['wallet']).to be_present
        expect(json_response['wallet']['balance']).to eq("0.0")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Team" do
        expect {
          post teams_url,
            params: { team: invalid_attributes },
            as: :json
        }.to change(Team, :count).by(0)
      end

      it "renders a JSON response with errors for the new team" do
        post teams_url,
          params: { team: invalid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(422)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        FactoryBot.attributes_for(:team, name: "New Name")
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        patch team_url(team),
          params: { team: new_attributes },
          headers: @valid_headers,
          as: :json
        team.reload
        expect(team.name).to eq("New Name")
      end

      it "renders a JSON response with the team" do
        team = Team.create! valid_attributes
        patch team_url(team),
          params: { team: new_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the team" do
        team = Team.create! valid_attributes
        patch team_url(team),
          params: { team: invalid_attributes },
          headers: @valid_headers,
          as: :json
        expect(response).to have_http_status(422)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
