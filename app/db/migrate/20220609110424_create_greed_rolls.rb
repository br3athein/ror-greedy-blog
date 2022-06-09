class CreateGreedRolls < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_rolls do |t|
      t.integer :player
      t.integer :order

      t.integer :dice_1
      t.integer :dice_2
      t.integer :dice_3
      t.integer :dice_4
      t.integer :dice_5

      t.boolean :dice_1_kept
      t.boolean :dice_2_kept
      t.boolean :dice_3_kept
      t.boolean :dice_4_kept
      t.boolean :dice_5_kept
    end
  end
end
