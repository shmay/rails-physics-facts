class Api::FactsController < Api::ApplicationController
  impressionist actions: [:show], :unique => [:impressionable_type, :impressionable_id, :session_hash]

  # GET /facts
  # GET /facts.json
  def index
    user_id = current_user ? current_user.id : nil
    @facts = Fact.all_with_stats(user_id)

    render json: @facts, each_serializer:FactSerializer
  end

  def show
    user_id = current_user ? current_user.id : nil
    @fact = Fact.find_with_stats(params[:id], user_id)

    render json: @fact
  end

  def create
    @fact = Fact.new(fact_params)
    @fact.user_id = current_user.id
    @fact.tag_list = params[:tag_list]

    if @fact.save
      render json: @fact, status: :created
    else
      render json: @fact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @vote.destroy

    head :no_content
  end
end
