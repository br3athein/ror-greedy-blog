class GreedSessionsController < ApplicationController
  def index
    @greed_sessions = GreedSession.all
  end

  def new
    @greed_session = GreedSession.new
  end

  def create
    @greed_session = GreedSession.new greed_session_params

    if @greed_session.save
      redirect_to @greed_session
    else
      render :index
    end
  end

  def show
    @greed_session = GreedSession.find params[:id]
  end

  # Roll a new set of dice.
  def roll
    @greed_session = GreedSession.find params[:id]
    @greed_session.next_roll roll_params

    redirect_to @greed_session
  end

  # Transfer the turn to other player.
  def pass
    @greed_session = GreedSession.find params[:id]

    @greed_session.advance_player_turn
    @greed_session.initial_roll
    @greed_session.save

    redirect_to @greed_session
  end

  private

  def greed_session_params
    params.require(:greed_session).permit(:players)
  end

  # Allow only `:dice_<i>' 1 thru 5 in `:keep'.
  def roll_params
    params.require(:keep).permit(
      (1..5).map do |i|
        "dice_#{i}".to_sym
      end)
  end
end
