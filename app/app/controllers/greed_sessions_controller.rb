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
    leg = @greed_session.current_leg
    leg.add_roll

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
end
