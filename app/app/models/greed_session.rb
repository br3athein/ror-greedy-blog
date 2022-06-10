class GreedSession < ApplicationRecord
  has_many :legs, class_name: 'GreedLeg', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }

  after_create :advance

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
end
