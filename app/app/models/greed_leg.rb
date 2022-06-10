class GreedLeg < ApplicationRecord
  belongs_to :session, class_name: 'GreedSession', foreign_key: :session_id
  has_many :rolls, class_name: 'GreedRoll', foreign_key: :leg_id

  before_create :assign_number

  def add_roll
    rolls.create
  end

  def gain
    return nil unless rolls.any?
    return rolls.last.score if rolls.count == 1

    rolls.last.score - rolls[-2].score
  end

  def terminal?
    rolls.last.terminal? || gain.zero?
  end

  private

  def assign_number
    self.number = session.legs.count + 1
  end
end
