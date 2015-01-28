class Api::VotesController < Api::ApplicationController
  before_action :logged_in_user

  def create
    @vote = Vote.new

    Vote.where(fact_id:params[:fact_id], user_id:current_user.id).each &:destroy

    @fact = Fact.find params[:fact_id]

    @vote.fact_id = @fact.id
    @vote.dir = params[:dir]
    @vote.user_id = current_user.id

    if @vote.save
      json = {
        vote: @vote,
        fact: @fact
      }
      render json: json, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end

end
