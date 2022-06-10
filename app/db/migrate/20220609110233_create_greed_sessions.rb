class CreateGreedSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_sessions do |t|
      t.integer :players, default: 2
      t.integer :showdown_initiator
      t.integer :winner

      t.timestamps
    end
  end
end
