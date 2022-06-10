class GreedSession < ApplicationRecord
  has_many :rolls, class_name: 'GreedRoll', foreign_key: :session_id
  validates :players, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  after_create :initial_roll

  def roll_next(keeps = nil)
    create_next_roll keeps
    advance_player_turn

    self
  end

  def next_roll(keeps)
    roll = rolls.new player: turn

    keeps.each do |dice, keep|
      keep = keep == '1'
      position = dice[/\d+/]
      roll.send "dice_#{position}_kept=", keep == '1'
      roll.send "dice_#{position}=", keep ? rolls.last.get_dice(position) : roll_single
    end

    roll.save
    roll
  end

  def advance_player_turn
    self.turn += 1
    self.turn -= players if turn > players
    self
  end

  def initial_roll
    roll = rolls.new player: turn
    roll.initial_roll.save
  end

  def roll_single
    rand(1..6)
  end
end
