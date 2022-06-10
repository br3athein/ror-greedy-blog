class GreedRoll < ApplicationRecord
  belongs_to :leg, class_name: 'GreedLeg', foreign_key: :leg_id
  before_create :assign_number
  before_create :roll

  # Dice faces that are unambiguously scoreable.
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

  # Calculate the score for the roll.
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

  # Does the roll has the three-of-a-kind on FACE?
  def triple_on?(face)
    dice.count(face) >= 3
  end

  def scoring?(pos)
    face = dice[pos]
    SCORING_DICES.include?(face) || triple_on?(face)
  end

  def scoring
    map_dice { |i| scoring? i }
  end

  # Is the dice set final and can't be improved?
  #
  # This is the same as saying that each position in the hand is scoreable.
  def terminal?
    !scoring.include? false
  end

  def fetch_ancestor
    leg.rolls.where(number: number - 1).first
  end

  # Roll the state of hand based on the previous hand in the leg.
  def roll
    ancestor = fetch_ancestor

    self.dice = map_dice do |i|
      if ancestor&.scoring?(i) && !ancestor.terminal?
        ancestor.dice[i]
      else
        roll_face
      end
    end

    self
  end

  private

  # Run a callback over each of hand's positions.
  def map_dice(&block)
    (0..4).map do |position|
      block.call position
    end
  end

  def roll_face
    rand(1..6)
  end

  def assign_number
    self.number = leg.rolls.count + 1
  end
end
