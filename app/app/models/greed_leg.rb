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

  def showdown
    self.final = true
    self
  end

  def showdown!
    showdown
    save
    self
  end

  def pun
    state = {
      gain: gain,
      score: score,
      rolls: rolls.count,
      terminal: rolls.last&.terminal?,
      botched: botched?,
      active: active?
    }

    case state
    in { gain: 0, rolls: 1 }
      'Oof, tough luck!'
    in { botched: true }
      %(Welp, that's why the game is called "Greed".)
    in { rolls: 1, terminal: true }
      'Strike!'
    in { terminal: true }
      "Nice, keep 'em coming!"

    # TODO: calibrate the score table, UI gets over-excited real fucking fast
    in { score: (1...500) }
      "Meh, I've seen better."
    in { score: (500...1000) }
      'Not great, not terrible.'
    in { score: (1000...1200) }
      'Nice run, innit?'
    in { score: (1200...1500) }
      'Good job!'
    in { score: (1500...) }
      'Sky is the limit.'

    else "What's it gonna be?" end
  end

  def peers
    session.legs.select do |leg|
      leg.player == player
    end
  end

  private

  def assign_number
    self.number = peers.count + 1
  end
end
