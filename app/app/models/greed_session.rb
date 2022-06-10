class GreedSession < ApplicationRecord
  has_many :legs, class_name: 'GreedLeg', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }

  after_create :advance

  ENTRY_SCORE = 300
  SHOWDOWN_SCORE = 3000

  def advance
    current_leg.terminate! if player_showdown?
    if player_has_moves? next_player
      legs.create player: next_player
    else
      proclaim_winner
    end
  end

  def proclaim_winner
    self.winner = player
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

  def player_legs(player)
    legs.where(player: player)
  end

  def opener_leg(player)
    player_legs(player).find { |leg| leg.score >= ENTRY_SCORE }
  end

  def persistent_legs
    opener = opener_leg(player)
    return [] unless opener

    player_legs(player).where(number: opener.number..)
  end

  def player_score(player)
    opener = opener_leg(player)
    return 0 unless opener

    player_legs(player).where(number: opener.number..).map(&:score).sum
  end

  def current_player_score
    player_score current_player
  end

  def showdown?
    scores.values.find { |score| showdown_score? score }
  end

  def score_showdown?(score)
    score >= SHOWDOWN_SCORE
  end

  def player_showdown?
    score_showdown? current_player_score
  end
end
