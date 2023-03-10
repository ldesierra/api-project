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

ActiveRecord::Schema[7.0].define(version: 2022_10_17_213814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cart_packs", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "pack_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_packs_on_cart_id"
    t.index ["pack_id"], name: "index_cart_packs_on_pack_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "restaurant_id"
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
    t.index ["restaurant_id"], name: "index_carts_on_restaurant_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_packs", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "pack_id", null: false
    t.index ["category_id"], name: "index_categories_packs_on_category_id"
    t.index ["pack_id"], name: "index_categories_packs_on_pack_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "username"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.datetime "deleted_at"
    t.string "avatar"
    t.index ["deleted_at"], name: "index_customers_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_customers_on_email_and_deleted_at", unique: true
    t.index ["jti"], name: "index_customers_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
    t.index ["username", "deleted_at"], name: "index_customers_on_username_and_deleted_at", unique: true
  end

  create_table "open_hours", force: :cascade do |t|
    t.integer "day"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id"
    t.index ["restaurant_id"], name: "index_open_hours_on_restaurant_id"
  end

  create_table "packs", force: :cascade do |t|
    t.string "name"
    t.integer "stock"
    t.text "full_description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id"
    t.text "short_description"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_packs_on_deleted_at"
    t.index ["restaurant_id"], name: "index_packs_on_restaurant_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "image"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable"
  end

  create_table "purchase_packs", force: :cascade do |t|
    t.bigint "pack_id", null: false
    t.bigint "purchase_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pack_id"], name: "index_purchase_packs_on_pack_id"
    t.index ["purchase_id"], name: "index_purchase_packs_on_purchase_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "restaurant_id", null: false
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "qualification", default: 0
    t.string "code"
    t.index ["customer_id"], name: "index_purchases_on_customer_id"
    t.index ["restaurant_id"], name: "index_purchases_on_restaurant_id"
  end

  create_table "restaurant_users", force: :cascade do |t|
    t.string "name"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "jti"
    t.bigint "restaurant_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "otp_access_token"
    t.string "phone_number"
    t.datetime "last_sent_otp"
    t.index ["confirmation_token"], name: "index_restaurant_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_restaurant_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_restaurant_users_on_email_and_deleted_at", unique: true
    t.index ["invitation_token"], name: "index_restaurant_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_restaurant_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_restaurant_users_on_invited_by"
    t.index ["jti"], name: "index_restaurant_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_restaurant_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_restaurant_users_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "status", default: 0, null: false
    t.string "logo"
    t.string "phone_number"
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["deleted_at"], name: "index_restaurants_on_deleted_at"
  end

  add_foreign_key "cart_packs", "carts"
  add_foreign_key "cart_packs", "packs"
  add_foreign_key "carts", "customers"
  add_foreign_key "carts", "restaurants"
  add_foreign_key "categories_packs", "categories"
  add_foreign_key "categories_packs", "packs"
  add_foreign_key "open_hours", "restaurants"
  add_foreign_key "packs", "restaurants"
  add_foreign_key "purchase_packs", "packs"
  add_foreign_key "purchase_packs", "purchases"
  add_foreign_key "purchases", "customers"
  add_foreign_key "purchases", "restaurants"
  add_foreign_key "restaurant_users", "restaurants"
end
