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

      t.boolean :dice_1_kept, comment: 'Whether dice 1 was kept on the previous roll'
      t.boolean :dice_2_kept, comment: 'Whether dice 2 was kept on the previous roll'
      t.boolean :dice_3_kept, comment: 'Whether dice 3 was kept on the previous roll'
      t.boolean :dice_4_kept, comment: 'Whether dice 4 was kept on the previous roll'
      t.boolean :dice_5_kept, comment: 'Whether dice 5 was kept on the previous roll'
    end
  end
end
