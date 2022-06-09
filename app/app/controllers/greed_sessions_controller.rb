class GreedSessionsController < ApplicationController
  def index
    @greed_sessions = GreedSession.all
  end

  def show
    @greed_session = GreedSession.find params[:id]
  end

  def create
    @greed_session = GreedSession.new

    if @greed_session.save
      redirect_to @greed_session
    else
      render :index
    end
  end
end
