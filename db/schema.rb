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

ActiveRecord::Schema.define(version: 20210131201508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_salida_bodegas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_salida_procesos", force: :cascade do |t|
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

  create_table "line_item_salida_bodegas", force: :cascade do |t|
    t.integer  "partida_id"
    t.integer  "cart_salida_bodega_id"
    t.bigint   "total_sacos",            default: 0
    t.bigint   "total_bolsas",           default: 0
    t.string   "total_kilogramos_netos", default: "0.00"
    t.integer  "salida_bodega_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["cart_salida_bodega_id"], name: "index_line_item_salida_bodegas_on_cart_salida_bodega_id", using: :btree
    t.index ["partida_id"], name: "index_line_item_salida_bodegas_on_partida_id", using: :btree
    t.index ["salida_bodega_id"], name: "index_line_item_salida_bodegas_on_salida_bodega_id", using: :btree
  end

  create_table "line_item_salida_procesos", force: :cascade do |t|
    t.integer  "partida_id"
    t.integer  "cart_salida_proceso_id"
    t.bigint   "total_sacos",            default: 0
    t.bigint   "total_bolsas",           default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "total_kilogramos_netos", default: "0.00"
    t.integer  "salida_proceso_id"
    t.index ["cart_salida_proceso_id"], name: "index_line_item_salida_procesos_on_cart_salida_proceso_id", using: :btree
    t.index ["partida_id"], name: "index_line_item_salida_procesos_on_partida_id", using: :btree
    t.index ["salida_proceso_id"], name: "index_line_item_salida_procesos_on_salida_proceso_id", using: :btree
  end

  create_table "mermas", force: :cascade do |t|
    t.integer  "merma_type",   default: 0
    t.date     "date_dry"
    t.string   "quantity"
    t.text     "observations"
    t.integer  "partida_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["partida_id"], name: "index_mermas_on_partida_id", using: :btree
  end

  create_table "partidas", force: :cascade do |t|
    t.bigint   "identificador",             default: 1
    t.integer  "entrada_id"
    t.string   "kilogramos_brutos"
    t.bigint   "numero_sacos"
    t.string   "tara"
    t.string   "kilogramos_netos"
    t.string   "humedad"
    t.integer  "type_coffee_id"
    t.string   "calidad_cafe"
    t.text     "observaciones"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.bigint   "numero_bolsas"
    t.string   "identificador_with_format"
    t.bigint   "numero_costalillas"
    t.index ["entrada_id"], name: "index_partidas_on_entrada_id", using: :btree
    t.index ["type_coffee_id"], name: "index_partidas_on_type_coffee_id", using: :btree
  end

  create_table "process_results", force: :cascade do |t|
    t.integer  "salida_proceso_id"
    t.string   "date"
    t.string   "rango_lote"
    t.string   "fecha_inicio"
    t.string   "fecha_termino"
    t.string   "humedad"
    t.string   "hora_inicio"
    t.string   "hora_termino"
    t.bigint   "equivalencia_sacos",  default: 69
    t.string   "total_kilos_totales"
    t.string   "total_porcentaje"
    t.string   "total_sacos"
    t.string   "total_kilos_sacos"
    t.string   "rendimiento"
    t.text     "observaciones"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["salida_proceso_id"], name: "index_process_results_on_salida_proceso_id", using: :btree
  end

  create_table "qualities", force: :cascade do |t|
    t.integer  "quality_type_id"
    t.integer  "process_result_id"
    t.string   "kilos_totales"
    t.string   "percentage"
    t.integer  "sacos"
    t.string   "kilos_sacos"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["process_result_id"], name: "index_qualities_on_process_result_id", using: :btree
    t.index ["quality_type_id"], name: "index_qualities_on_quality_type_id", using: :btree
  end

  create_table "quality_types", force: :cascade do |t|
    t.string   "name"
    t.bigint   "orden",           default: 1
    t.boolean  "is_to_increment", default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "salida_bodegas", force: :cascade do |t|
    t.string   "name_driver"
    t.string   "name_person"
    t.integer  "client_id"
    t.string   "tipo_cafe"
    t.integer  "total_sacos"
    t.integer  "total_bolsas"
    t.string   "total_kilogramos_netos"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "observaciones"
    t.integer  "numero_salida",          default: 0
    t.integer  "numero_salida_cliente",  default: 0
    t.index ["client_id"], name: "index_salida_bodegas_on_client_id", using: :btree
  end

  create_table "salida_procesos", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "tipo_cafe"
    t.bigint   "total_sacos",            default: 0
    t.bigint   "total_bolsas",           default: 0
    t.string   "total_kilogramos_netos", default: "0.00"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.text     "observaciones"
    t.integer  "numero_salida",          default: 0
    t.integer  "numero_salida_cliente",  default: 0
    t.index ["client_id"], name: "index_salida_procesos_on_client_id", using: :btree
  end

  create_table "type_coffees", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_historical", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "entradas", "clients"
  add_foreign_key "line_item_salida_bodegas", "cart_salida_bodegas"
  add_foreign_key "line_item_salida_bodegas", "partidas"
  add_foreign_key "line_item_salida_bodegas", "salida_bodegas"
  add_foreign_key "line_item_salida_procesos", "cart_salida_procesos"
  add_foreign_key "line_item_salida_procesos", "partidas"
  add_foreign_key "line_item_salida_procesos", "salida_procesos"
  add_foreign_key "mermas", "partidas"
  add_foreign_key "partidas", "entradas"
  add_foreign_key "partidas", "type_coffees"
  add_foreign_key "process_results", "salida_procesos"
  add_foreign_key "qualities", "process_results"
  add_foreign_key "qualities", "quality_types"
  add_foreign_key "salida_bodegas", "clients"
  add_foreign_key "salida_procesos", "clients"
end
