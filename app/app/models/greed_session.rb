class GreedSession < ApplicationRecord
  has_many :legs, class_name: 'GreedLeg', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }

  after_create :advance

  ENTRY_SCORE = 300
  SHOWDOWN_SCORE = 3000

  def advance
    return legs.create player: next_player unless sudden_death!

    proclaim_winner!
  end

  # Check if the game has ended.
  def sudden_death!
    enforce_endgame_conditions

    # game always ends in the showdown...
    return false unless showdown?

    # ...and after each of the players has broke a leg in it.
    next_player == showdown_initiator
  end

  # Check if the current player starts the showdown.
  def enforce_endgame_conditions
    self.showdown_initiator ||= current_player if player_hits_showdown?
    save if showdown?
  end

  def showdown?
    !showdown_initiator.nil?
  end

  def proclaim_winner
    self.winner, = scores.max_by { |_, score| score }
  end

  def proclaim_winner!
    proclaim_winner
    save
  end

  def current_player
    return 1 unless legs.any?

    current_leg.player
  end

  def next_player
    return 1 unless legs.any?
    return 1 if current_player == players

    current_player + 1
  end

  def turn
    current_player
  end

  def current_leg
    legs.last
  end

  def scores
    (1..players).map do |i|
      [i, player_score(i)]
    end.to_h
  end

  # All of PLAYER's legs.
  def player_legs(player = current_player)
    legs.where(player: player)
  end

  # Return a first leg that exceeded the entry score for PLAYER.
  def opener_leg(player = current_player)
    player_legs(player).find { |leg| leg.score >= ENTRY_SCORE }
  end

  # Sum scores on PLAYER's legs contributing to the final score.
  def player_score(player = current_player)
    opener = opener_leg player
    return 0 unless opener

    player_legs(player).where(number: opener.number..).map(&:score).sum
  end

  # Tell whether PLAYER has bought-in in the game.
  #
  # Meaning that the PLAYER has a leg with worth at least ENTRY_SCORE points
  def player_in_game?(player = current_player)
    !opener_leg(player).nil?
  end

  # Does the current player initiate showdown?
  def player_hits_showdown?
    player_score >= SHOWDOWN_SCORE
  end
end
