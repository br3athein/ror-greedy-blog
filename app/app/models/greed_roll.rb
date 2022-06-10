class GreedRoll < ApplicationRecord
  belongs_to :leg, class_name: 'GreedLeg', foreign_key: :leg_id
  before_create :assign_number
  before_create :roll

  SCORING_DICES = [1, 5].freeze

  def dice(pos = nil)
    if pos.is_a? Integer
      send "dice_#{pos}"
    else
      map_dice { |i| dice i }
    end
  end

  def dice=(new_dice)
    new_dice.each_with_index do |value, i|
      send "dice_#{i}=", value
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

  def triple_on?(number)
    dice.count(number) >= 3
  end

  def scoring?(pos)
    value = dice[pos]
    SCORING_DICES.include?(value) || triple_on?(value)
  end

  def scoring
    map_dice { |i| scoring? i }
  end

  def terminal?
    !scoring.include? false
  end

  def fetch_ancestor
    leg.rolls.where(number: number - 1).first
  end

  def roll
    ancestor = fetch_ancestor

    self.dice = map_dice do |i|
      if ancestor&.scoring?(i) && !ancestor.terminal?
        ancestor.dice[i]
      else
        roll_single
      end
    end

    self
  end

  private

  def map_dice(&block)
    (0..4).map do |i|
      block.call i
    end
  end

  def roll_single
    rand(1..6)
  end

  def assign_number
    self.number = leg.rolls.count + 1
  end
end
