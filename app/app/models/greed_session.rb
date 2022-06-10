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
    self.showdown_initiator ||= current_player if player_hits_showdown?

    # game always ends in the showdown
    return false unless showdown?

    save

    # ...after each of the players has broke a leg in it.
    next_player == showdown_initiator
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

    legs.last.player
  end

  def next_player
    return 1 unless legs.any?
    return 1 if current_player == players

    current_player + 1
  end

  def player_has_moves?(player)
    !player_legs(player).last.final?
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

  def player_legs(player = current_player)
    legs.where(player: player)
  end

  def opener_leg(player = current_player)
    player_legs(player).find { |leg| leg.score >= ENTRY_SCORE }
  end

  def persistent_legs(player = current_player)
    opener = opener_leg(player)
    return [] unless opener

    player_legs(player).where(number: opener.number..)
  end

  def player_score(player = current_player)
    opener = opener_leg player
    return 0 unless opener

    player_legs(player).where(number: opener.number..).map(&:score).sum
  end

  def player_in_game?(player = current_player)
    !opener_leg(player).nil?
  end

  def player_hits_showdown?
    player_score >= SHOWDOWN_SCORE
  end
end
