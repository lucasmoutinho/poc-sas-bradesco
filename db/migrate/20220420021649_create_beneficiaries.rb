class CreateBeneficiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :beneficiaries do |t|
      t.decimal :card, precision: 15, scale: 0
      t.string :name
      t.string :finantial_status
      t.string :register_status

      t.timestamps
    end
    add_index :beneficiaries, :card
  end
end
