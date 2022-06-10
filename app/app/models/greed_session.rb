class GreedSession < ApplicationRecord
  has_many :legs, class_name: 'GreedLeg', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }

  after_create :advance

  ENTRY_SCORE = 300

  def advance
    legs.create player: next_player
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
end
