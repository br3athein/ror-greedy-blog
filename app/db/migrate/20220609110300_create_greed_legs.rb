class CreateGreedLegs < ActiveRecord::Migration[7.0]
  def change
    create_table :greed_legs do |t|
      t.references :session, null: false, foreign_key: { to_table: :greed_sessions }

      t.integer :number, comment: 'An order of the leg in the session'
      t.integer :player, comment: 'A player running this leg'
    end
  end
end
