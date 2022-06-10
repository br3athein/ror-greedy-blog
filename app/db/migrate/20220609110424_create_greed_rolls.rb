class CreateGreedRolls < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_rolls do |t|
      t.references :session, null: false, foreign_key: { to_table: :greed_sessions }

      t.integer :player, comment: 'A player that makes the roll'
      t.integer :number, comment: 'The roll number'

      t.integer :dice_1, comment: 'Score on dice 1'
      t.integer :dice_2, comment: 'Score on dice 2'
      t.integer :dice_3, comment: 'Score on dice 3'
      t.integer :dice_4, comment: 'Score on dice 4'
      t.integer :dice_5, comment: 'Score on dice 5'
    end
  end
end
