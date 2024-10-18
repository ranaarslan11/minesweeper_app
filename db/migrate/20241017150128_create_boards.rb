class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.string :name
      t.string :email
      t.integer :width
      t.integer :height
      t.integer :mines
      t.text :board_data
      t.text :revealed_data
      t.text :flagged_data
      t.boolean :game_over, default: false
      t.timestamps
    end
  end
end
