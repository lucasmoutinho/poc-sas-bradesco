class CreateReferenceds < ActiveRecord::Migration[6.1]
  def change
    create_table :referenceds do |t|
      t.integer :code
      t.decimal :cnpj_code, precision: 15, scale: 0
      t.string :name
      t.string :register_status

      t.timestamps
    end
    add_index :referenceds, :cnpj_code
  end
end
