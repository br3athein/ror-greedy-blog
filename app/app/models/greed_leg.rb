class GreedLeg < ApplicationRecord
  belongs_to :session, class_name: 'GreedSession', foreign_key: :session_id
  has_many :rolls, class_name: 'GreedRoll', foreign_key: :leg_id

  before_create :assign_number

  def add_roll
    rolls.create
  end

  def gain(on = rolls.count)
    raise ArgumentError, "`on' is the natural order argument!" if on.negative?

    return nil if on.zero?
    return rolls.first.score if on == 1

    rolls[on - 1].score - rolls[on - 2].score
  end

  def terminal?
    rolls.last.terminal? || botched?
  end

  def scoreable?
    !botched?
  end

  def botched?
    gain.zero?
  end

  private

  def assign_number
    self.number = session.legs.count + 1
  end
end
