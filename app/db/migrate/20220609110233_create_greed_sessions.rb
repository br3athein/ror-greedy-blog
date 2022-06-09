class CreateGreedSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_sessions do |t|
      t.integer :players
      t.integer :turn, default: 1

      t.timestamps
    end
  end
end
