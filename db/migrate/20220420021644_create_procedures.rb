class CreateProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.string :table_type
      t.integer :code
      t.string :description
      t.string :guide

      t.timestamps
    end
    add_index :procedures, :code
  end
end
