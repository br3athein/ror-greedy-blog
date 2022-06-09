class GreedRoll < ApplicationRecord
  belongs_to :session, class_name: 'GreedSession', foreign_key: :session_id

  def dice
    (1..5).map do |i|
      send "dice_#{i}"
    end
  end

  def kept?(pos)
    send "dice_#{pos}_kept"
  end

  def get_dice(pos)
    send "dice_#{pos}"
  end

  def initial_roll
    (1..5).each do |i|
      send "dice_#{i}=", roll_single
    end

    self
  end

  def roll_single
    rand(1..6)
  end
end
