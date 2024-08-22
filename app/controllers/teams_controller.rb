class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show update ]

  # GET /teams
  def index
    @teams = Team.all

    render json: @teams.as_json(include: :wallet)
  end

  # GET /teams/1
  def show
    render json: @team.as_json(include: :wallet)
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      render json: @team.as_json(include: :wallet), status: :created, location: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      render json: @team.as_json(include: :wallet)
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name)
    end
end
