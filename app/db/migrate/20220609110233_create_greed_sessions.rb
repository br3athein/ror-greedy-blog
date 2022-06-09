class CreateGreedSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_sessions do |t|
      t.integer :players
      t.boolean :ongoing, default: true
      t.integer :winner

      t.timestamps
    end
  end
end
