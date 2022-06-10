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

    pre_last, last = rolls.second_to_last, rolls.last
    return last.score if pre_last.terminal?

    last.score - pre_last.score
  end

  def score
    return 0 if botched? || rolls.empty?

    total = rolls.select(&:terminal?).inject(0) do |acc, roll|
      acc + roll.score
    end

    total += rolls.last.score unless rolls.last.terminal?

    total
  end

  def active?
    session.legs.last == self
  end

  def live?
    !botched?
  end

  def botched?
    gain&.zero?
  end

  def pun
    case [gain, rolls.count, rolls.last&.terminal?]
    in [0, 1, _]
      'Oof, tough luck!'
    in [0, _, false]
      %|Welp, that's why the game is called "Greed".|
    in [_, 1, true]
      'Strike!'
    else nil end
  end

  private

  def assign_number
    self.number = session.legs.count + 1
  end
end
