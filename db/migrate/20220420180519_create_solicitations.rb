class CreateSolicitations < ActiveRecord::Migration[6.1]
  def change
    create_table :solicitations do |t|
      t.references :beneficiary, null: false, foreign_key: true
      t.references :procedure, null: false, foreign_key: true
      t.references :referenced, null: false, foreign_key: true
      t.boolean :attachment_exam_guide
      t.boolean :attachment_medical_report
      t.boolean :automatic_release
      t.boolean :adm_analysis
      t.boolean :medic_analysis
      t.string :result

      t.timestamps
    end
  end
end
