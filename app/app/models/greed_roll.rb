class GreedRoll < ApplicationRecord
  belongs_to :session, class_name: 'GreedSession', foreign_key: :session_id
  after_create :assign_number

  def assign_number
    self.number = session.rolls.count + 1
  end

  def dice(pos = nil)
    if pos.is_a? Integer
      send "dice_#{pos}"
    else
      map_dice { |i| dice i }
    end
  end

  def dice=(new_dice)
    new_dice.each_with_index do |value, i|
      send "dice_#{i + 1}=", value
    end
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

  def scoring
    dice.map do |i|
      [1, 5].include?(i) || dice.count(i) >= 3
    end
  end

  def scoring?(pos)
    scoring[pos - 1]
  end

  # Roll non-scoring positions. Or everything, if this is a first roll.
  def roll
    previous_roll = session&.rolls&.last

    map_dice do |i|
      send "dice_#{i}=", if previous_roll&.scoring?(i)
                           previous_roll.dice i
                         else
                           roll_single
                         end
    end

    self
  end

  def map_dice(&block)
    (1..5).map do |i|
      block.call i
    end
  end

  def roll_single
    rand(1..6)
  end
end
