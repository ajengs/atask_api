require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid with valid attributes" do
    team = Team.new(name: "Team 1")
    expect(team).to be_valid
  end

  it "is not valid without a name" do
    team = Team.new(name: nil)
    expect(team).to_not be_valid
  end
end
