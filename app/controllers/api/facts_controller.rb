require 'byebug'

class Api::FactsController < Api::ApplicationController
  before_filter :logged_in_user, only: [:create, :update]

  impressionist actions: [:show], :unique => [:impressionable_type, :impressionable_id, :session_hash]

  # GET /facts
  # GET /facts.json
  def index
    user_id = current_user ? current_user.id : nil
    @facts = Fact.shallow_facts(user_id)

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
      render json: @fact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @fact = Fact.find(params[:id])

    if @fact.user_id == current_user.id
      if @fact.update(fact_params)
        @fact = Fact.find_with_stats(@fact.id,current_user.id)
        render json: @fact
      else
        render json: @fact.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: {error: "This is not yo fact breh!"}, status: :unprocessable_entity
    end
  end

  def star
    star = Starring.where(user_id:current_user.id,fact_id:params[:id]).first

    if star
      star.destroy
      render json: star
    else
      star = Starring.create(user_id:current_user.id,fact_id:params[:id])

      render json: star, status: :created
    end
  end

  def destroy
    @fact.destroy

    head :no_content
  end

  private
    
    def fact_params
      params.require(:fact).permit(:title, :body, :tag_list => [])
    end
end
