# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171009204848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_salidas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "legal_representative"
    t.text     "address"
    t.string   "organization"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "persona_fisica",       default: false
    t.boolean  "is_historical",        default: false
    t.boolean  "delete_logical",       default: false
  end

  create_table "entradas", force: :cascade do |t|
    t.datetime "date"
    t.bigint   "numero_entrada"
    t.string   "driver"
    t.string   "entregado_por"
    t.bigint   "total_partidas",         default: 1
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "delete_logical",         default: false
    t.integer  "client_id"
    t.bigint   "numero_entrada_cliente", default: 0
    t.index ["client_id"], name: "index_entradas_on_client_id", using: :btree
  end

  create_table "line_item_salidas", force: :cascade do |t|
    t.integer  "partida_id"
    t.integer  "cart_salida_id"
    t.bigint   "total_sacos",    default: 0
    t.bigint   "total_bolsas",   default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["cart_salida_id"], name: "index_line_item_salidas_on_cart_salida_id", using: :btree
    t.index ["partida_id"], name: "index_line_item_salidas_on_partida_id", using: :btree
  end

  create_table "partidas", force: :cascade do |t|
    t.bigint   "identificador",     default: 1
    t.integer  "entrada_id"
    t.string   "kilogramos_brutos"
    t.bigint   "numero_sacos"
    t.string   "tara"
    t.string   "kilogramos_netos"
    t.string   "humedad"
    t.integer  "type_coffee_id"
    t.string   "calidad_cafe"
    t.text     "observaciones"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.bigint   "numero_bolsas"
    t.index ["entrada_id"], name: "index_partidas_on_entrada_id", using: :btree
    t.index ["type_coffee_id"], name: "index_partidas_on_type_coffee_id", using: :btree
  end

  create_table "type_coffees", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_historical", default: false
  end

  add_foreign_key "entradas", "clients"
  add_foreign_key "line_item_salidas", "cart_salidas"
  add_foreign_key "line_item_salidas", "partidas"
  add_foreign_key "partidas", "entradas"
  add_foreign_key "partidas", "type_coffees"
end
