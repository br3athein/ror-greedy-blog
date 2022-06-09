# The class is dead, don't use it.
# @deprecated
class GreedController < ApplicationController
  def interface
    (1..5).each do |position|
      load_pos position
    end

    @score = score dice
  end

  def rules; end

  def roll
    dice_params.each do |field, keep|
      reroll extract_pos(field) unless keep == '1'
    end

    redirect_to '/greed'
  end

  private

  def dice_params
    params.permit(%i[dice_1 dice_2 dice_3 dice_4 dice_5])
  end

  def load_pos(pos)
    varname = dice_varname pos
    reroll pos if session[varname].nil?
    instance_variable_set varname, session[varname]
  end

  # Reroll the piece of dice at position `POS' and store it in the session.
  def reroll(pos)
    varname = dice_varname pos
    session[varname] = rand(1..6)
    instance_variable_set varname, session[varname]
  end

  def dice_varname(pos)
    "@dice_#{pos}"
  end

  def extract_pos(fieldname)
    fieldname[/^dice_(\d+)$/, 1]
  end

  def dice
    (1..5).map { |pos| instance_variable_get dice_varname pos }
  end

  def score(dice)
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
