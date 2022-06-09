class GreedSession < ApplicationRecord
  has_many :rolls, class_name: 'GreedRoll', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  after_create :initial_roll

  def roll(keeps = nil)
    roll = rolls.new player: turn

    keeps.each do |dice, keep|
      keep = keep == '1'
      position = dice[/\d+/]
      roll.send "dice_#{position}_kept", keep == '1'
      roll.send "dice_#{position}=", keep ? new_roll : rolls.last.get_dice(pos)
    end

    roll.save
  end

  def initial_roll
    rolls.new.initial_roll.save
  end

  def roll_single
    rand(1..6)
  end
end
