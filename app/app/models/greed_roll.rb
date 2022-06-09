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

  def score
    (1..6).inject(0) do |acc, i|
      count = dice.count i
      acc += i == 1 ? 1000 : 100 * i if count >= 3

      count -= 3 if count >= 3
      acc += 100 * count if i == 1
      acc += 50 * count if i == 5

      acc
    end
  end
end
