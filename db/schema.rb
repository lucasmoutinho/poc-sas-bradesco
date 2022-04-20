# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_20_180519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beneficiaries", force: :cascade do |t|
    t.decimal "card", precision: 15
    t.string "name"
    t.string "finantial_status"
    t.string "register_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card"], name: "index_beneficiaries_on_card"
  end

  create_table "procedures", force: :cascade do |t|
    t.string "table_type"
    t.integer "code"
    t.string "description"
    t.string "guide"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_procedures_on_code"
  end

  create_table "referenceds", force: :cascade do |t|
    t.integer "code"
    t.decimal "cnpj_code", precision: 15
    t.string "name"
    t.string "register_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cnpj_code"], name: "index_referenceds_on_cnpj_code"
  end

  create_table "solicitations", force: :cascade do |t|
    t.bigint "beneficiary_id", null: false
    t.bigint "procedure_id", null: false
    t.bigint "referenced_id", null: false
    t.boolean "attachment_exam_guide"
    t.boolean "attachment_medical_report"
    t.boolean "automatic_release"
    t.boolean "adm_analysis"
    t.boolean "medic_analysis"
    t.string "result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["beneficiary_id"], name: "index_solicitations_on_beneficiary_id"
    t.index ["procedure_id"], name: "index_solicitations_on_procedure_id"
    t.index ["referenced_id"], name: "index_solicitations_on_referenced_id"
  end

  add_foreign_key "solicitations", "beneficiaries"
  add_foreign_key "solicitations", "procedures"
  add_foreign_key "solicitations", "referenceds"
end
