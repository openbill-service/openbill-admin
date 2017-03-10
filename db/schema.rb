# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170310151236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "intarray"
  enable_extension "pg_trgm"
  enable_extension "uuid-ossp"

  create_table "access_tokens", force: :cascade do |t|
    t.integer  "vendor_id",               null: false
    t.integer  "operator_id",             null: false
    t.string   "token",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_tokens", ["operator_id"], name: "index_access_tokens_on_operator_id", using: :btree
  add_index "access_tokens", ["token"], name: "index_access_tokens_on_token", unique: true, using: :btree
  add_index "access_tokens", ["vendor_id"], name: "index_access_tokens_on_vendor_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "vendor_id"
    t.string   "card_first_six",      limit: 255, null: false
    t.string   "card_last_four",      limit: 255, null: false
    t.string   "card_type",           limit: 255, null: false
    t.string   "issuer_bank_country", limit: 255
    t.text     "token",                           null: false
    t.string   "card_exp_date",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["token"], name: "index_accounts_on_token", unique: true, using: :btree
  add_index "accounts", ["vendor_id"], name: "index_accounts_on_vendor_id", using: :btree

  create_table "acme_authorize_domains", force: :cascade do |t|
    t.string  "domain",        limit: 255, null: false
    t.string  "token",         limit: 255, null: false
    t.string  "content",       limit: 255, null: false
    t.string  "verify_status", limit: 255
    t.integer "vendor_id"
  end

  add_index "acme_authorize_domains", ["domain", "token"], name: "index_acme_authorize_domains_on_domain_and_token", using: :btree
  add_index "acme_authorize_domains", ["domain"], name: "index_acme_authorize_domains_on_domain", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255,                 null: false
    t.string   "resource_type", limit: 255,                 null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_auto",                   default: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",       null: false
    t.string   "encrypted_password",     limit: 255, default: "",       null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255, default: "vendor", null: false
    t.string   "name",                   limit: 255
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "asset_images", force: :cascade do |t|
    t.integer  "vendor_id",  null: false
    t.text     "image",      null: false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_images", ["vendor_id"], name: "index_asset_images_on_vendor_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.string   "provider",             limit: 255,                 null: false
    t.string   "uid",                  limit: 255,                 null: false
    t.text     "auth_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirmed",                        default: false, null: false
    t.integer  "authenticatable_id",                               null: false
    t.string   "authenticatable_type", limit: 255,                 null: false
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.integer  "vendor_id",                                          null: false
    t.text     "image"
    t.text     "h1"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.text     "meta_title"
    t.string   "cached_default_slug",     limit: 255
    t.boolean  "is_active",                           default: true, null: false
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.hstore   "title_translations"
    t.hstore   "content_translations"
    t.hstore   "short_text_translations"
  end

  add_index "blog_posts", ["vendor_id"], name: "index_blog_posts_on_vendor_id", using: :btree

  create_table "branch_categories", force: :cascade do |t|
    t.string   "CategoryId",    limit: 255,             null: false
    t.string   "CategoryGroup", limit: 255,             null: false
    t.string   "title",         limit: 255,             null: false
    t.integer  "position",                  default: 0, null: false
    t.integer  "shops_count",               default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branch_categories", ["CategoryId", "CategoryGroup", "title"], name: "branch_categories_index", unique: true, using: :btree

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id",                                                                null: false
    t.integer  "good_id",                                                                null: false
    t.integer  "count",                                          default: 0,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "good_type",  limit: 255,                         default: "ProductItem", null: false
    t.decimal  "weight_kg",              precision: 8, scale: 2
  end

  add_index "cart_items", ["cart_id", "good_type", "good_id"], name: "index_cart_items_on_cart_id_and_good_type_and_good_id", unique: true, using: :btree
  add_index "cart_items", ["cart_id"], name: "index_cart_items_on_cart_id", using: :btree
  add_index "cart_items", ["good_id"], name: "index_cart_items_on_good_id", using: :btree

  create_table "carts", force: :cascade do |t|
    t.string   "session_id",        limit: 255,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id",                                 null: false
    t.integer  "items_count",                   default: 0
    t.string   "remote_ip",         limit: 255
    t.string   "coupon_code",       limit: 255
    t.integer  "package_good_id"
    t.string   "package_good_type", limit: 255
    t.integer  "package_count"
  end

  add_index "carts", ["vendor_id", "session_id"], name: "index_carts_on_vendor_id_and_session_id", unique: true, using: :btree
  add_index "carts", ["vendor_id"], name: "index_carts_on_vendor_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                                   default: 0,    null: false
    t.string   "ancestry",                      limit: 255
    t.integer  "products_count",                             default: 0,    null: false
    t.integer  "published_products_count",                   default: 0,    null: false
    t.string   "ms_uuid",                       limit: 255
    t.datetime "stock_synced_at"
    t.text     "stock_dump"
    t.string   "externalcode",                  limit: 255
    t.datetime "deleted_at"
    t.integer  "vk_album_id"
    t.integer  "active_products_count",                      default: 0
    t.integer  "deep_products_count",                        default: 0
    t.integer  "deep_published_products_count",              default: 0
    t.integer  "deep_active_products_count",                 default: 0
    t.text     "stock_description"
    t.text     "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "h1",                            limit: 255
    t.string   "image",                         limit: 4096
    t.string   "cached_default_slug",           limit: 255
    t.datetime "vk_synced_at"
    t.string   "stock_title",                   limit: 255
    t.boolean  "show_children_products",                     default: true, null: false
    t.hstore   "custom_title_translations"
    t.hstore   "description_translations"
    t.hstore   "bottom_text_translations"
    t.hstore   "cached_title_translations"
    t.integer  "next_resource_id"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  add_index "categories", ["deep_published_products_count"], name: "index_categories_on_deep_published_products_count", using: :btree
  add_index "categories", ["vendor_id", "cached_default_slug"], name: "index_categories_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "categories", ["vendor_id", "externalcode"], name: "index_categories_on_vendor_id_and_externalcode", unique: true, using: :btree
  add_index "categories", ["vendor_id", "ms_uuid"], name: "index_categories_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "categories", ["vendor_id", "published_products_count"], name: "index_categories_on_vendor_id_and_published_products_count", using: :btree
  add_index "categories", ["vendor_id", "vk_album_id"], name: "index_categories_on_vendor_id_and_vk_album_id", unique: true, using: :btree
  add_index "categories", ["vendor_id"], name: "index_categories_on_vendor_id", using: :btree

  create_table "categories_coupons", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "coupon_id"
  end

  add_index "categories_coupons", ["category_id"], name: "index_categories_coupons_on_category_id", using: :btree
  add_index "categories_coupons", ["coupon_id"], name: "index_categories_coupons_on_coupon_id", using: :btree

  create_table "category_products", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "product_id"
    t.integer  "row_order",   default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_main",     default: false, null: false
  end

  add_index "category_products", ["category_id"], name: "index_category_products_on_category_id", using: :btree
  add_index "category_products", ["product_id"], name: "index_category_products_on_product_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "client_emails", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "email",        limit: 255,                 null: false
    t.boolean  "confirmed",                default: false, null: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_emails", ["client_id"], name: "index_client_emails_on_client_id", using: :btree
  add_index "client_emails", ["email", "client_id"], name: "index_client_emails_on_email_and_client_id", unique: true, using: :btree

  create_table "client_phones", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "phone",        limit: 255,                 null: false
    t.boolean  "confirmed",                default: false, null: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_phones", ["client_id"], name: "index_client_phones_on_client_id", using: :btree
  add_index "client_phones", ["phone", "client_id"], name: "index_client_phones_on_phone_and_client_id", unique: true, using: :btree

  create_table "clients", force: :cascade do |t|
    t.integer  "vendor_id",                                null: false
    t.string   "name",             limit: 255,             null: false
    t.integer  "orders_count",                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_order_id"
    t.string   "pin_code",         limit: 255
    t.datetime "pin_requested_at"
  end

  add_index "clients", ["vendor_id"], name: "index_clients_on_vendor_id", using: :btree

  create_table "content_page_images", force: :cascade do |t|
    t.integer  "content_page_id",                          null: false
    t.integer  "vendor_id",                                null: false
    t.string   "image",           limit: 4096,             null: false
    t.integer  "position",                     default: 0, null: false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_pages", force: :cascade do |t|
    t.integer  "vendor_id",                                        null: false
    t.integer  "position",                         default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                        default: true,  null: false
    t.boolean  "target_blank",                     default: false
    t.string   "h1",                   limit: 255
    t.text     "meta_keywords"
    t.string   "meta_description",     limit: 255
    t.text     "meta_title"
    t.string   "cached_default_slug",  limit: 255
    t.datetime "deleted_at"
    t.hstore   "title_translations"
    t.hstore   "content_translations"
  end

  add_index "content_pages", ["vendor_id", "cached_default_slug"], name: "index_content_pages_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "content_pages", ["vendor_id", "position"], name: "index_content_pages_on_vendor_id_and_position", using: :btree
  add_index "content_pages", ["vendor_id"], name: "index_content_pages_on_vendor_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.integer  "vendor_id",                                                    null: false
    t.string   "code",                    limit: 255,                          null: false
    t.integer  "use_count"
    t.integer  "used_count",                          default: 0
    t.integer  "discount",                                                     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expires_at"
    t.string   "discount_type",           limit: 255, default: "percent",      null: false
    t.string   "type",                    limit: 255, default: "CouponSingle", null: false
    t.integer  "group_id"
    t.integer  "pieces_count",                        default: 0,              null: false
    t.string   "description",             limit: 255
    t.boolean  "only_first_order",                    default: false,          null: false
    t.boolean  "is_check_address",                    default: false,          null: false
    t.boolean  "free_delivery",                       default: false,          null: false
    t.integer  "minimal_products_count"
    t.string   "use_products_behavior",   limit: 255, default: "include",      null: false
    t.string   "use_categories_behavior", limit: 255, default: "include",      null: false
  end

  add_index "coupons", ["code", "vendor_id"], name: "index_coupons_on_code_and_vendor_id", unique: true, using: :btree

  create_table "coupons_products", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "coupon_id"
  end

  add_index "coupons_products", ["coupon_id"], name: "index_coupons_products_on_coupon_id", using: :btree
  add_index "coupons_products", ["product_id"], name: "index_coupons_products_on_product_id", using: :btree

  create_table "dictionaries", force: :cascade do |t|
    t.integer  "vendor_id",                                                    null: false
    t.string   "stock_title",               limit: 255
    t.string   "externalcode",              limit: 255
    t.string   "ms_uuid",                   limit: 255
    t.datetime "stock_synced_at"
    t.text     "description"
    t.datetime "deleted_at"
    t.text     "stock_dump"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stock_description"
    t.text     "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "h1",                        limit: 255
    t.string   "key",                       limit: 255,                        null: false
    t.integer  "entities_count",                        default: 0,            null: false
    t.integer  "entities_alive_count",                  default: 0,            null: false
    t.string   "cached_default_slug",       limit: 255
    t.string   "type",                      limit: 255, default: "Dictionary", null: false
    t.string   "image",                     limit: 255
    t.hstore   "custom_title_translations"
    t.hstore   "cached_title_translations"
  end

  add_index "dictionaries", ["vendor_id", "cached_default_slug"], name: "index_dictionaries_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "dictionaries", ["vendor_id", "externalcode"], name: "index_dictionaries_on_vendor_id_and_externalcode", unique: true, using: :btree
  add_index "dictionaries", ["vendor_id", "key"], name: "index_dictionaries_on_vendor_id_and_key", unique: true, using: :btree
  add_index "dictionaries", ["vendor_id", "ms_uuid"], name: "index_dictionaries_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "dictionaries", ["vendor_id", "stock_title"], name: "index_dictionaries_on_vendor_id_and_stock_title", using: :btree

  create_table "dictionary_entities", force: :cascade do |t|
    t.integer  "vendor_id",                                         null: false
    t.integer  "dictionary_id",                                     null: false
    t.string   "stock_title",               limit: 255
    t.integer  "position",                              default: 0, null: false
    t.string   "externalcode",              limit: 255
    t.string   "ms_uuid",                   limit: 255
    t.datetime "stock_synced_at"
    t.datetime "deleted_at"
    t.text     "stock_dump"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stock_description"
    t.integer  "products_count",                        default: 0, null: false
    t.integer  "published_products_count",              default: 0, null: false
    t.text     "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "h1",                        limit: 255
    t.string   "cached_default_slug",       limit: 255
    t.string   "color_hex",                 limit: 255
    t.string   "image",                     limit: 255
    t.integer  "active_products_count",                 default: 0, null: false
    t.integer  "archived_products_count",               default: 0, null: false
    t.hstore   "custom_title_translations"
    t.hstore   "cached_title_translations"
    t.hstore   "description_translations"
    t.integer  "next_resource_id"
  end

  add_index "dictionary_entities", ["dictionary_id"], name: "index_dictionary_entities_on_dictionary_id", using: :btree
  add_index "dictionary_entities", ["products_count"], name: "index_dictionary_entities_on_products_count", using: :btree
  add_index "dictionary_entities", ["published_products_count"], name: "index_dictionary_entities_on_published_products_count", using: :btree
  add_index "dictionary_entities", ["vendor_id", "cached_default_slug"], name: "index_dictionary_entities_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "dictionary_entities", ["vendor_id", "externalcode"], name: "index_dictionary_entities_on_vendor_id_and_externalcode", unique: true, using: :btree
  add_index "dictionary_entities", ["vendor_id", "ms_uuid"], name: "index_dictionary_entities_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "dictionary_entities", ["vendor_id", "stock_title"], name: "index_dictionary_entities_on_vendor_id_and_stock_title", using: :btree
  add_index "dictionary_entities", ["vendor_id"], name: "index_dictionary_entities_on_vendor_id", using: :btree

  create_table "domain_aliases", force: :cascade do |t|
    t.integer  "vendor_id",              null: false
    t.string   "domain",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domain_aliases", ["domain"], name: "index_domain_aliases_on_domain", unique: true, using: :btree
  add_index "domain_aliases", ["vendor_id"], name: "index_domain_aliases_on_vendor_id", using: :btree

  create_table "flipper_features", force: :cascade do |t|
    t.string   "key",        limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "flipper_features", ["key"], name: "index_flipper_features_on_key", unique: true, using: :btree

  create_table "flipper_gates", force: :cascade do |t|
    t.string   "feature_key", limit: 255, null: false
    t.string   "key",         limit: 255, null: false
    t.string   "value",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "flipper_gates", ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true, using: :btree

  create_table "history_paths", force: :cascade do |t|
    t.text     "path",                                              null: false
    t.integer  "vendor_id",                                         null: false
    t.integer  "state",                       default: 0,           null: false
    t.string   "controller_name", limit: 255,                       null: false
    t.string   "action_name",     limit: 255,                       null: false
    t.string   "resource_type",   limit: 255
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "referer"
    t.string   "content_type",    limit: 255, default: "text/html"
    t.integer  "count",                       default: 0,           null: false
    t.text     "user_agent"
    t.integer  "response_state",              default: 0,           null: false
  end

  add_index "history_paths", ["vendor_id", "path"], name: "index_history_paths_on_vendor_id_and_path", unique: true, using: :btree
  add_index "history_paths", ["vendor_id", "response_state"], name: "index_history_paths_on_vendor_id_and_response_state", using: :btree
  add_index "history_paths", ["vendor_id", "state", "content_type"], name: "index_history_paths_on_vendor_id_and_state_and_content_type", using: :btree
  add_index "history_paths", ["vendor_id", "state", "updated_at"], name: "index_history_paths_on_vendor_id_and_state_and_updated_at", using: :btree

  create_table "import_spread_sheet_infos", force: :cascade do |t|
    t.integer  "vendor_id",                                           null: false
    t.string   "google_spreadsheet_url",  limit: 255
    t.integer  "state",                               default: 0,     null: false
    t.integer  "skip_rows",                           default: 1,     null: false
    t.text     "column_definitions"
    t.integer  "imported_products_count",             default: 0,     null: false
    t.integer  "total_rows_count"
    t.integer  "imported_rows_count",                 default: 0,     null: false
    t.text     "rows"
    t.text     "result_messages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_this_product_items",               default: false, null: false
  end

  add_index "import_spread_sheet_infos", ["vendor_id"], name: "index_import_spread_sheet_infos_on_vendor_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "operator_inviter_id",                                 null: false
    t.integer  "vendor_id",                                           null: false
    t.string   "email",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",                 limit: 255,                     null: false
    t.string   "phone",               limit: 255
    t.string   "role",                limit: 255, default: "manager"
    t.integer  "role_id"
  end

  add_index "invites", ["email", "vendor_id"], name: "index_invites_on_email_and_vendor_id", unique: true, using: :btree
  add_index "invites", ["key"], name: "index_invites_on_key", unique: true, using: :btree
  add_index "invites", ["vendor_id", "phone"], name: "index_invites_on_vendor_id_and_phone", unique: true, using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "phone",             limit: 255, null: false
    t.integer  "amocrm_lead_id"
    t.string   "visitor_uid",       limit: 255
    t.string   "landing_page_url",  limit: 255
    t.string   "referer",           limit: 255
    t.text     "utm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amocrm_contact_id", limit: 255
  end

  create_table "lookbook_images", force: :cascade do |t|
    t.integer  "lookbook_id",                          null: false
    t.integer  "vendor_id",                            null: false
    t.string   "image",       limit: 4096,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                 default: 0, null: false
    t.integer  "width"
    t.integer  "height"
  end

  create_table "lookbooks", force: :cascade do |t|
    t.integer  "vendor_id",                                      null: false
    t.integer  "position"
    t.string   "title",               limit: 255,                null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                       default: true, null: false
    t.string   "h1",                  limit: 255
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.text     "meta_title"
    t.string   "cached_default_slug", limit: 255
    t.integer  "images_count",                    default: 0,    null: false
  end

  add_index "lookbooks", ["vendor_id", "cached_default_slug"], name: "index_lookbooks_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "lookbooks", ["vendor_id"], name: "index_lookbooks_on_vendor_id", using: :btree

  create_table "mail_templates", force: :cascade do |t|
    t.string   "key",          limit: 255,                null: false
    t.integer  "vendor_id"
    t.string   "subject",      limit: 255
    t.text     "content_html"
    t.text     "content_text"
    t.text     "content_sms"
    t.string   "locale",       limit: 255, default: "ru", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace",    limit: 255,                null: false
    t.boolean  "allow_sms",                default: true, null: false
    t.boolean  "allow_email",              default: true, null: false
  end

  add_index "mail_templates", ["vendor_id", "namespace", "key"], name: "index_mail_templates_on_vendor_id_and_namespace_and_key", unique: true, using: :btree
  add_index "mail_templates", ["vendor_id"], name: "index_mail_templates_on_vendor_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "vendor_id"
    t.integer  "operator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",               limit: 255
    t.string   "token",              limit: 255, default: "",   null: false
    t.datetime "last_signed_at"
    t.boolean  "email_notification",             default: true, null: false
    t.boolean  "sms_notification",               default: true, null: false
    t.integer  "role_id"
  end

  add_index "members", ["operator_id", "vendor_id"], name: "index_members_on_operator_id_and_vendor_id", unique: true, using: :btree
  add_index "members", ["operator_id"], name: "index_members_on_operator_id", using: :btree
  add_index "members", ["vendor_id"], name: "index_members_on_vendor_id", using: :btree

  create_table "menu_items", force: :cascade do |t|
    t.integer  "vendor_id",                                            null: false
    t.integer  "position"
    t.string   "place",                     limit: 255
    t.string   "type",                      limit: 255
    t.integer  "category_id"
    t.integer  "dictionary_entity_id"
    t.integer  "dictionary_id"
    t.integer  "content_page_id"
    t.text     "link_url"
    t.boolean  "is_active",                             default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lookbook_id"
    t.datetime "deleted_at"
    t.hstore   "custom_title_translations"
  end

  add_index "menu_items", ["vendor_id", "place", "position"], name: "index_menu_items_on_vendor_id_and_place_and_position", using: :btree

  create_table "openbill_accounts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "category_id",                                       null: false
    t.string   "key",                limit: 256,                    null: false
    t.decimal  "amount_cents",                    default: 0.0,     null: false
    t.string   "amount_currency",    limit: 3,    default: "USD",   null: false
    t.text     "details"
    t.integer  "transactions_count",              default: 0,       null: false
    t.hstore   "meta",                            default: {},      null: false
    t.datetime "created_at",                      default: "now()"
    t.datetime "updated_at",                      default: "now()"
    t.string   "url",                limit: 2096
  end

  add_index "openbill_accounts", ["created_at"], name: "index_accounts_on_created_at", using: :btree
  add_index "openbill_accounts", ["id"], name: "index_accounts_on_id", unique: true, using: :btree
  add_index "openbill_accounts", ["key"], name: "index_accounts_on_key", unique: true, using: :btree
  add_index "openbill_accounts", ["meta"], name: "index_accounts_on_meta", using: :gin

  create_table "openbill_categories", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "name",      limit: 256, null: false
    t.uuid   "parent_id"
  end

  add_index "openbill_categories", ["parent_id", "name"], name: "index_openbill_categories_name", unique: true, using: :btree

  create_table "openbill_invoices", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "date",                                                 null: false
    t.string   "number",                 limit: 256,                   null: false
    t.string   "title",                  limit: 256,                   null: false
    t.uuid     "destination_account_id",                               null: false
    t.decimal  "amount_cents",                       default: 0.0,     null: false
    t.string   "amount_currency",        limit: 3,   default: "USD",   null: false
    t.datetime "created_at",                         default: "now()"
    t.datetime "updated_at",                         default: "now()"
  end

  add_index "openbill_invoices", ["id"], name: "index_invoices_on_id", unique: true, using: :btree
  add_index "openbill_invoices", ["number"], name: "index_invoices_on_number", unique: true, using: :btree

  create_table "openbill_policies", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string  "name",             limit: 256,                null: false
    t.uuid    "from_category_id"
    t.uuid    "to_category_id"
    t.uuid    "from_account_id"
    t.uuid    "to_account_id"
    t.boolean "allow_reverse",                default: true, null: false
  end

  add_index "openbill_policies", ["name"], name: "index_openbill_policies_name", unique: true, using: :btree

  create_table "openbill_transactions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username",               limit: 255,                   null: false
    t.datetime "created_at",                         default: "now()"
    t.uuid     "from_account_id",                                      null: false
    t.uuid     "to_account_id",                                        null: false
    t.decimal  "amount_cents",                                         null: false
    t.string   "amount_currency",        limit: 3,                     null: false
    t.string   "key",                    limit: 256,                   null: false
    t.text     "details",                                              null: false
    t.hstore   "meta",                               default: {},      null: false
    t.date     "date"
    t.uuid     "reverse_transaction_id"
    t.integer  "operation_id"
  end

  add_index "openbill_transactions", ["created_at"], name: "index_transactions_on_created_at", using: :btree
  add_index "openbill_transactions", ["key"], name: "index_transactions_on_key", unique: true, using: :btree
  add_index "openbill_transactions", ["meta"], name: "index_transactions_on_meta", using: :gin

  create_table "openbill_webhook_logs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "level",          limit: 256,                   null: false
    t.string   "message",        limit: 256,                   null: false
    t.string   "pid",            limit: 256,                   null: false
    t.string   "url",            limit: 256,                   null: false
    t.uuid     "transaction_id",                               null: false
    t.string   "status",         limit: 256
    t.datetime "created_at",                 default: "now()"
  end

  add_index "openbill_webhook_logs", ["level"], name: "openbill_webhook_logs_on_level", using: :btree
  add_index "openbill_webhook_logs", ["transaction_id"], name: "openbill_webhook_logs_on_transaction_id", using: :btree

  create_table "operators", force: :cascade do |t|
    t.string   "name",                            limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                           limit: 255
    t.string   "crypted_password",                limit: 255
    t.string   "salt",                            limit: 255
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "failed_logins_count",                         default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token",                    limit: 255
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address",      limit: 255
    t.string   "remember_me_token",               limit: 255
    t.datetime "remember_me_token_expires_at"
    t.string   "phone",                           limit: 255
    t.datetime "last_signed_at"
    t.datetime "email_confirmed_at"
    t.datetime "phone_confirmed_at"
    t.string   "email_confirm_token",             limit: 255
    t.integer  "amocrm_contact_id"
    t.boolean  "is_super_admin",                              default: false, null: false
    t.string   "system_subscriptions",            limit: 255, default: [],    null: false, array: true
  end

  add_index "operators", ["email"], name: "index_operators_on_email", unique: true, using: :btree
  add_index "operators", ["last_logout_at", "last_activity_at"], name: "index_operators_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "operators", ["phone"], name: "index_operators_on_phone", unique: true, using: :btree
  add_index "operators", ["remember_me_token"], name: "index_operators_on_remember_me_token", using: :btree
  add_index "operators", ["reset_password_token"], name: "index_operators_on_reset_password_token", using: :btree
  add_index "operators", ["unlock_token"], name: "index_operators_on_unlock_token", using: :btree

  create_table "order_condition_orders", force: :cascade do |t|
    t.integer  "order_id",           null: false
    t.integer  "order_condition_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_condition_orders", ["order_condition_id"], name: "index_order_condition_orders_on_order_condition_id", using: :btree
  add_index "order_condition_orders", ["order_id"], name: "index_order_condition_orders_on_order_id", using: :btree

  create_table "order_conditions", force: :cascade do |t|
    t.integer  "vendor_id",                                          null: false
    t.integer  "vendor_delivery_id"
    t.integer  "vendor_payment_id"
    t.integer  "enter_workflow_state_id"
    t.string   "event",                      limit: 255,             null: false
    t.string   "enter_finite_state",         limit: 255
    t.string   "action",                     limit: 255,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "used_count",                             default: 0, null: false
    t.datetime "used_at"
    t.integer  "position"
    t.datetime "deleted_at"
    t.integer  "after_time_minutes"
    t.string   "notification_template",      limit: 255
    t.string   "order_payment_state",        limit: 255
    t.string   "order_delivery_state",       limit: 255
    t.integer  "to_order_workflow_state_id"
  end

  add_index "order_conditions", ["enter_workflow_state_id"], name: "index_order_conditions_on_enter_workflow_state_id", using: :btree
  add_index "order_conditions", ["vendor_delivery_id"], name: "index_order_conditions_on_vendor_delivery_id", using: :btree
  add_index "order_conditions", ["vendor_id", "vendor_delivery_id", "vendor_payment_id", "enter_workflow_state_id", "event", "enter_finite_state"], name: "order_conditions_index", using: :btree
  add_index "order_conditions", ["vendor_id"], name: "index_order_conditions_on_vendor_id", using: :btree
  add_index "order_conditions", ["vendor_payment_id"], name: "index_order_conditions_on_vendor_payment_id", using: :btree

  create_table "order_deliveries", force: :cascade do |t|
    t.string   "type",                  limit: 255,                 null: false
    t.integer  "order_id",                                          null: false
    t.string   "external_id",           limit: 255
    t.string   "state",                 limit: 255, default: "new", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "agent_notify_at"
    t.string   "agent_notify_state",    limit: 255
    t.text     "agent_notify_dump"
    t.text     "agent_notify_fields"
    t.string   "agent_notify_redirect", limit: 255
    t.datetime "date_from"
    t.datetime "date_till"
    t.datetime "expires_at"
    t.string   "clean_address",         limit: 500
    t.string   "postal_code",           limit: 255
    t.string   "country",               limit: 255
    t.string   "region",                limit: 255
    t.string   "city",                  limit: 255
    t.string   "street",                limit: 255
    t.string   "house",                 limit: 255
    t.string   "block",                 limit: 255
    t.string   "flat",                  limit: 255
  end

  add_index "order_deliveries", ["order_id"], name: "index_order_deliveries_on_order_id", unique: true, using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",                                                                       null: false
    t.integer  "count",                                                  default: 0,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_kopeks",                                           default: 0,             null: false
    t.string   "price_currency",     limit: 255,                         default: "RUB",         null: false
    t.integer  "good_id",                                                                        null: false
    t.string   "good_type",          limit: 255,                         default: "ProductItem", null: false
    t.decimal  "weight_kg",                      precision: 8, scale: 2
    t.decimal  "weight_of_price",                precision: 8, scale: 2
    t.boolean  "selling_by_weight",                                      default: false,         null: false
    t.hstore   "title_translations"
  end

  create_table "order_local_stocks", force: :cascade do |t|
    t.integer  "order_id",                                         null: false
    t.datetime "reserved_at"
    t.datetime "unreserved_at"
    t.boolean  "is_reserved",                      default: false, null: false
    t.string   "reservation_result",   limit: 255, default: "0",   null: false
    t.string   "unreservation_result", limit: 255, default: "0",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_local_stocks", ["order_id"], name: "index_order_local_stocks_on_order_id", using: :btree

  create_table "order_log_entities", force: :cascade do |t|
    t.integer  "order_id",   null: false
    t.integer  "author_id"
    t.text     "message",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_log_entities", ["order_id", "id"], name: "index_order_log_entities_on_order_id_and_id", using: :btree

  create_table "order_operator_filters", force: :cascade do |t|
    t.string  "name",               limit: 255,             null: false
    t.string  "color_hex",          limit: 255
    t.integer "row_order",                      default: 0, null: false
    t.integer "vendor_id"
    t.integer "workflow_state_id"
    t.boolean "has_reserved_items"
    t.string  "delivery_state",     limit: 255
    t.string  "payment_state",      limit: 255
    t.integer "delivery_type_id"
    t.integer "payment_type_id"
    t.integer "coupon_id"
  end

  add_index "order_operator_filters", ["vendor_id"], name: "index_order_operator_filters_on_vendor_id", using: :btree

  create_table "order_payments", force: :cascade do |t|
    t.string   "type",        limit: 255,                 null: false
    t.integer  "order_id",                                null: false
    t.string   "external_id", limit: 255
    t.string   "state",       limit: 255, default: "new", null: false
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_payments", ["order_id"], name: "index_order_payments_on_order_id", unique: true, using: :btree

  create_table "order_remote_stocks", force: :cascade do |t|
    t.integer  "order_id",                                         null: false
    t.string   "ms_order_uuid",        limit: 255
    t.text     "ms_order_dump"
    t.datetime "reserved_at"
    t.datetime "unreserved_at"
    t.boolean  "is_reserved",                      default: false, null: false
    t.integer  "reservation_result",               default: 0,     null: false
    t.integer  "unreservation_result",             default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_remote_stocks", ["order_id"], name: "index_order_remote_stocks_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "phone",                              limit: 255
    t.string   "name",                               limit: 255
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id",                                                      null: false
    t.string   "address",                            limit: 255
    t.integer  "city_id"
    t.integer  "delivery_type_id",                                               null: false
    t.integer  "payment_type_id",                                                null: false
    t.string   "city_title",                         limit: 255
    t.string   "email",                              limit: 255
    t.datetime "deleted_at"
    t.string   "slug",                               limit: 255,                 null: false
    t.integer  "coupon_id"
    t.integer  "products_price_kopeks",                                          null: false
    t.string   "products_price_currency",            limit: 255,                 null: false
    t.integer  "total_price_kopeks",                                             null: false
    t.string   "total_price_currency",               limit: 255,                 null: false
    t.integer  "delivery_price_kopeks",                          default: 0,     null: false
    t.string   "delivery_price_currency",            limit: 255,                 null: false
    t.integer  "total_with_delivery_price_kopeks",                               null: false
    t.string   "total_with_delivery_price_currency", limit: 255,                 null: false
    t.integer  "discount",                                       default: 0,     null: false
    t.integer  "discount_price_kopeks",                                          null: false
    t.string   "discount_price_currency",            limit: 255,                 null: false
    t.string   "coupon_code",                        limit: 255
    t.string   "package_good_id",                    limit: 255
    t.string   "package_good_type",                  limit: 255
    t.integer  "package_price_kopeks",                           default: 0,     null: false
    t.string   "package_price_currency",             limit: 255
    t.integer  "client_id",                                                      null: false
    t.datetime "will_cancel_at"
    t.string   "ip",                                 limit: 255
    t.text     "ip_location"
    t.text     "user_agent"
    t.integer  "workflow_state_id",                                              null: false
    t.integer  "free_delivery_threshold_kopeks",                 default: 0,     null: false
    t.string   "free_delivery_threshold_currency",   limit: 255, default: "RUB"
    t.integer  "cart_id"
    t.integer  "items_count",                                    default: 0,     null: false
    t.boolean  "is_delivery_expiration_notified",                default: false, null: false
    t.string   "convead_guest_uid",                  limit: 255
    t.string   "currency_iso_code",                  limit: 255, default: "RUB", null: false
    t.boolean  "address_parsed",                                 default: false, null: false
    t.string   "locale",                             limit: 255, default: "ru",  null: false
    t.integer  "package_count"
  end

  add_index "orders", ["client_id"], name: "index_orders_on_client_id", using: :btree
  add_index "orders", ["slug"], name: "index_orders_on_slug", unique: true, using: :btree
  add_index "orders", ["vendor_id", "coupon_code"], name: "index_orders_on_vendor_id_and_coupon_code", using: :btree
  add_index "orders", ["vendor_id", "will_cancel_at"], name: "index_orders_on_vendor_id_and_will_cancel_at", using: :btree
  add_index "orders", ["vendor_id", "workflow_state_id"], name: "index_orders_on_vendor_id_and_workflow_state_id", using: :btree

  create_table "partner_coupons", force: :cascade do |t|
    t.string   "code",           limit: 255,               null: false
    t.integer  "active_days",                default: 365, null: false
    t.integer  "reward_percent",             default: 15,  null: false
    t.integer  "partner_id",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_coupons", ["code"], name: "index_partner_coupons_on_code", unique: true, using: :btree
  add_index "partner_coupons", ["partner_id"], name: "index_partner_coupons_on_partner_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "name",                 limit: 255, null: false
    t.uuid     "billing_account_uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "vendor_id",                       null: false
    t.string   "card_first_six",      limit: 255, null: false
    t.string   "card_last_four",      limit: 255, null: false
    t.string   "card_type",           limit: 255, null: false
    t.string   "issuer_bank_country", limit: 255
    t.text     "token",                           null: false
    t.string   "card_exp_date",       limit: 255, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "gateway",             limit: 255, null: false
  end

  add_index "payment_accounts", ["token"], name: "index_payment_accounts_on_token", unique: true, using: :btree
  add_index "payment_accounts", ["vendor_id"], name: "index_payment_accounts_on_vendor_id", using: :btree

  create_table "payment_to_deliveries", force: :cascade do |t|
    t.integer  "vendor_payment_id",  null: false
    t.integer  "vendor_delivery_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_to_deliveries", ["vendor_delivery_id"], name: "index_payment_to_deliveries_on_vendor_delivery_id", using: :btree
  add_index "payment_to_deliveries", ["vendor_payment_id", "vendor_delivery_id"], name: "payment_to_deliveries_uniqueness", unique: true, using: :btree
  add_index "payment_to_deliveries", ["vendor_payment_id"], name: "index_payment_to_deliveries_on_vendor_payment_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.hstore   "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree

  create_table "phone_confirmations", force: :cascade do |t|
    t.string   "phone",            limit: 255,                 null: false
    t.integer  "operator_id",                                  null: false
    t.boolean  "is_confirmed",                 default: false, null: false
    t.string   "pin_code",         limit: 255,                 null: false
    t.datetime "pin_requested_at"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_confirmations", ["operator_id", "phone"], name: "index_phone_confirmations_on_operator_id_and_phone", unique: true, using: :btree
  add_index "phone_confirmations", ["operator_id"], name: "index_phone_confirmations_on_operator_id", using: :btree

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image",                  limit: 4096,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_main",                             default: false
    t.integer  "vendor_id",                                           null: false
    t.integer  "position",                            default: 0,     null: false
    t.integer  "width"
    t.integer  "height"
    t.text     "saved_remote_image_url"
    t.string   "digest",                 limit: 255
  end

  add_index "product_images", ["product_id", "is_main", "id"], name: "index_product_images_on_product_id_and_is_main_and_id", order: {"is_main"=>:desc, "id"=>:desc}, using: :btree
  add_index "product_images", ["vendor_id"], name: "index_product_images_on_vendor_id", using: :btree

  create_table "product_items", force: :cascade do |t|
    t.integer  "product_id",                                            null: false
    t.string   "article",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "data",                                  default: {}
    t.integer  "vendor_id",                                             null: false
    t.decimal  "quantity",                              default: 0.0
    t.text     "stock_dump"
    t.datetime "stock_synced_at"
    t.string   "ms_uuid",                   limit: 255
    t.string   "ms_consignment_uuid",       limit: 255
    t.text     "description"
    t.datetime "deleted_at"
    t.hstore   "unique_properties"
    t.string   "externalcode",              limit: 255
    t.decimal  "stock"
    t.decimal  "reserve"
    t.datetime "quantity_synced_at"
    t.text     "stock_description"
    t.boolean  "is_default",                            default: false, null: false
    t.text     "consignment_dump"
    t.hstore   "custom_title_translations"
    t.hstore   "cached_title_translations"
  end

  add_index "product_items", ["product_id", "externalcode"], name: "index_product_items_on_product_id_and_externalcode", unique: true, using: :btree
  add_index "product_items", ["product_id"], name: "index_product_items_on_product_id", using: :btree
  add_index "product_items", ["product_id"], name: "product_id_and_deleted_at", where: "(deleted_at IS NULL)", using: :btree
  add_index "product_items", ["vendor_id", "article"], name: "index_product_items_on_vendor_id_and_article", using: :btree
  add_index "product_items", ["vendor_id", "ms_consignment_uuid"], name: "index_product_items_on_vendor_id_and_ms_consignment_uuid", unique: true, using: :btree
  add_index "product_items", ["vendor_id", "ms_uuid"], name: "index_product_items_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "product_items", ["vendor_id", "quantity_synced_at"], name: "index_product_items_on_vendor_id_and_quantity_synced_at", using: :btree
  add_index "product_items", ["vendor_id", "stock_synced_at"], name: "index_product_items_on_vendor_id_and_stock_synced_at", using: :btree

  create_table "product_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_tags", ["product_id"], name: "index_product_tags_on_product_id", using: :btree
  add_index "product_tags", ["tag_id", "product_id"], name: "index_product_tags_on_tag_id_and_product_id", unique: true, using: :btree
  add_index "product_tags", ["tag_id"], name: "index_product_tags_on_tag_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id",                                                                                     null: false
    t.integer  "price_kopeks"
    t.string   "price_currency",                  limit: 255
    t.integer  "position",                                                            default: 0,               null: false
    t.string   "article",                         limit: 255
    t.hstore   "data",                                                                default: {},              null: false
    t.integer  "items_count",                                                         default: 0,               null: false
    t.boolean  "is_published",                                                        default: false
    t.string   "brand",                           limit: 255
    t.string   "ms_uuid",                         limit: 255
    t.integer  "images_count",                                                        default: 0,               null: false
    t.boolean  "has_ordering_goods",                                                  default: false,           null: false
    t.datetime "deleted_at"
    t.datetime "stock_synced_at"
    t.string   "externalcode",                    limit: 255
    t.decimal  "weight"
    t.decimal  "volume"
    t.string   "ms_code",                         limit: 255
    t.boolean  "is_serial_trackable",                                                 default: false
    t.decimal  "quantity"
    t.decimal  "stock"
    t.decimal  "reserve"
    t.string   "ms_consignment_uuid",             limit: 255
    t.datetime "quantity_synced_at"
    t.text     "stock_dump"
    t.integer  "sale_price_kopeks"
    t.boolean  "is_sale",                                                             default: false,           null: false
    t.boolean  "is_manual_published",                                                 default: true
    t.integer  "categories_ids",                                                      default: [],              null: false, array: true
    t.string   "vk_photo_id",                     limit: 255
    t.integer  "vk_album_id"
    t.integer  "image_ids",                                                           default: [],              null: false, array: true
    t.string   "sale_price_currency",             limit: 255
    t.integer  "similar_products_ids",                                                default: [],              null: false, array: true
    t.string   "type",                            limit: 255,                         default: "Product",       null: false
    t.integer  "product_union_id"
    t.hstore   "category_positions",                                                  default: {},              null: false
    t.integer  "union_position",                                                      default: 0,               null: false
    t.string   "stock_title",                     limit: 255
    t.text     "stock_description"
    t.integer  "dictionary_entity_ids",                                               default: [],              null: false, array: true
    t.text     "video_url"
    t.text     "consignment_dump"
    t.text     "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "h1",                              limit: 255
    t.string   "cached_default_slug",             limit: 255
    t.string   "show_similar_products",           limit: 255,                         default: "auto"
    t.boolean  "is_new",                                                              default: false,           null: false
    t.text     "cached_image_url"
    t.text     "cached_public_url"
    t.boolean  "ordering_as_product_only",                                            default: false,           null: false
    t.datetime "vk_synced_at"
    t.datetime "tasty_published_at"
    t.string   "tasty_entry_id",                  limit: 255
    t.boolean  "selling_by_weight",                                                   default: false,           null: false
    t.decimal  "weight_of_price",                             precision: 8, scale: 2
    t.hstore   "custom_title_translations"
    t.hstore   "custom_description_translations"
    t.hstore   "cached_title_translations"
    t.hstore   "cached_description_translations"
    t.integer  "other_products_ids",                                                  default: [],              null: false, array: true
    t.string   "show_other_products",             limit: 255,                         default: "selected_only"
    t.integer  "cached_category_ids",                                                 default: [],              null: false, array: true
    t.integer  "main_category_id"
    t.boolean  "multiple_choice",                                                     default: false,           null: false
  end

  add_index "products", ["categories_ids"], name: "index_products_on_categories_ids", using: :gin
  add_index "products", ["category_positions"], name: "index_products_on_category_positions", using: :gin
  add_index "products", ["dictionary_entity_ids"], name: "index_products_on_dictionary_entity_ids", using: :gin
  add_index "products", ["has_ordering_goods"], name: "index_products_on_has_ordering_goods", using: :btree
  add_index "products", ["product_union_id"], name: "index_products_on_product_union_id", using: :btree
  add_index "products", ["vendor_id", "article"], name: "index_products_on_vendor_id_and_article", using: :btree
  add_index "products", ["vendor_id", "cached_default_slug"], name: "index_products_on_vendor_id_and_cached_default_slug", using: :btree
  add_index "products", ["vendor_id", "deleted_at"], name: "index_products_on_vendor_id_and_deleted_at", using: :btree
  add_index "products", ["vendor_id", "externalcode"], name: "index_products_on_vendor_id_and_externalcode", unique: true, using: :btree
  add_index "products", ["vendor_id", "is_published", "product_union_id"], name: "index_published_products", where: "(deleted_at IS NULL)", using: :btree
  add_index "products", ["vendor_id", "ms_consignment_uuid"], name: "index_products_on_vendor_id_and_ms_consignment_uuid", unique: true, using: :btree
  add_index "products", ["vendor_id", "ms_uuid"], name: "index_products_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "products", ["vendor_id", "quantity_synced_at"], name: "index_products_on_vendor_id_and_quantity_synced_at", using: :btree
  add_index "products", ["vendor_id", "type"], name: "index_products_on_vendor_id_and_type", using: :btree

  create_table "role_permissions", force: :cascade do |t|
    t.string   "resource_type", limit: 255,                 null: false
    t.boolean  "can_read",                  default: false, null: false
    t.boolean  "can_create",                default: false, null: false
    t.boolean  "can_update",                default: false, null: false
    t.boolean  "can_delete",                default: false, null: false
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_permissions", ["resource_type", "role_id"], name: "index_role_permissions_on_resource_type_and_role_id", unique: true, using: :btree
  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "key",        limit: 255, null: false
    t.integer  "vendor_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["vendor_id", "key"], name: "index_roles_on_vendor_id_and_key", unique: true, using: :btree

  create_table "sale_graph_entities", force: :cascade do |t|
    t.integer "selling_vendors_month", null: false
    t.integer "selling_vendors_week",  null: false
    t.date    "date",                  null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "slider_images", force: :cascade do |t|
    t.integer  "vendor_id",                                   null: false
    t.integer  "position",                                    null: false
    t.boolean  "is_active",                default: true,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "link_url"
    t.datetime "deleted_at"
    t.integer  "width"
    t.integer  "height"
    t.string   "image",       limit: 4096
    t.string   "link_target", limit: 255,  default: "_blank", null: false
  end

  add_index "slider_images", ["vendor_id", "is_active", "position"], name: "index_slider_images_on_vendor_id_and_is_active_and_position", using: :btree
  add_index "slider_images", ["vendor_id"], name: "index_slider_images_on_vendor_id", using: :btree

  create_table "slugs", force: :cascade do |t|
    t.string   "path",          limit: 255,                          null: false
    t.integer  "vendor_id",                                          null: false
    t.string   "resource_id",   limit: 255
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",          limit: 255, default: "SlugResource", null: false
    t.string   "redirect_path", limit: 255
  end

  add_index "slugs", ["resource_type", "resource_id"], name: "index_slugs_on_resource_type_and_resource_id", using: :btree
  add_index "slugs", ["vendor_id", "path"], name: "index_slugs_on_vendor_id_and_path", unique: true, using: :btree
  add_index "slugs", ["vendor_id", "redirect_path"], name: "index_slugs_on_vendor_id_and_redirect_path", using: :btree
  add_index "slugs", ["vendor_id", "resource_id", "resource_type"], name: "index_slugs_on_vendor_id_and_resource_id_and_resource_type", unique: true, where: "((type)::text = 'SlugResource'::text)", using: :btree
  add_index "slugs", ["vendor_id", "type"], name: "index_slugs_on_vendor_id_and_type", using: :btree
  add_index "slugs", ["vendor_id"], name: "index_slugs_on_vendor_id", using: :btree

  create_table "stock_importing_log_entities", force: :cascade do |t|
    t.integer  "vendor_id",                           null: false
    t.hstore   "data",                   default: {}, null: false
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      limit: 255
  end

  add_index "stock_importing_log_entities", ["vendor_id", "created_at"], name: "index_stock_importing_log_entities_on_vendor_id_and_created_at", using: :btree
  add_index "stock_importing_log_entities", ["vendor_id"], name: "index_stock_importing_log_entities_on_vendor_id", using: :btree

  create_table "subscription_emails", force: :cascade do |t|
    t.string   "email",      limit: 255, null: false
    t.integer  "vendor_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscription_emails", ["vendor_id", "email"], name: "index_subscription_emails_on_vendor_id_and_email", unique: true, using: :btree

  create_table "system_mail_deliveries", force: :cascade do |t|
    t.integer  "system_mail_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                   limit: 255,                   null: false
    t.string   "state",                   limit: 255, default: "draft", null: false
  end

  create_table "system_mail_recipients", force: :cascade do |t|
    t.integer  "system_mail_delivery_id", null: false
    t.integer  "vendor_id",               null: false
    t.integer  "operator_id",             null: false
    t.datetime "send_at"
    t.datetime "open_at"
    t.datetime "follow_link_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_mail_recipients", ["system_mail_delivery_id", "vendor_id", "operator_id"], name: "unique_system_mail_delivery_entity", unique: true, using: :btree

  create_table "system_mail_templates", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "subject",       limit: 255
    t.text     "content"
    t.string   "template_type", limit: 255,                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "footer"
    t.string   "image",         limit: 255
    t.string   "type",          limit: 255, default: "SystemMailTemplate", null: false
  end

  create_table "system_texts", force: :cascade do |t|
    t.string "title",   limit: 255, null: false
    t.string "key",     limit: 255, null: false
    t.text   "content"
  end

  create_table "tags", force: :cascade do |t|
    t.hstore   "title_translations"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["vendor_id"], name: "index_tags_on_vendor_id", using: :btree

  create_table "tariff_orders", force: :cascade do |t|
    t.integer  "tariff_id"
    t.integer  "from_orders_count",                    default: 0,     null: false
    t.integer  "to_orders_count",                      default: 0,     null: false
    t.integer  "per_order_price_kopeks",               default: 0,     null: false
    t.string   "per_order_price_currency", limit: 255, default: "RUB", null: false
    t.integer  "per_month_price_kopeks",               default: 0,     null: false
    t.string   "per_month_price_currency", limit: 255, default: "RUB", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tariff_orders", ["tariff_id"], name: "index_tariff_orders_on_tariff_id", using: :btree

  create_table "tariffs", force: :cascade do |t|
    t.string   "title",                              limit: 255,                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_send_sms_with_negative_balance",             default: false
    t.integer  "sms_price_kopeks",                               default: 0,               null: false
    t.string   "sms_price_currency",                 limit: 255, default: "RUB",           null: false
    t.integer  "moysklad_price_kopeks",                          default: 0,               null: false
    t.string   "moysklad_price_currency",            limit: 255, default: "RUB",           null: false
    t.integer  "link_kiosk_disable_price_kopeks",                default: 0,               null: false
    t.string   "link_kiosk_disable_price_currency",  limit: 255, default: "RUB",           null: false
    t.string   "type",                               limit: 255, default: "TariffByOrder", null: false
    t.integer  "row_order",                                      default: 0,               null: false
    t.text     "description"
    t.integer  "feature_max_users",                              default: 2,               null: false
    t.boolean  "feature_export_data",                            default: false,           null: false
    t.boolean  "feature_edit_menu",                              default: false,           null: false
    t.boolean  "feature_rbk_money",                              default: false,           null: false
    t.boolean  "feature_yandex_kassa",                           default: false,           null: false
    t.boolean  "feature_package",                                default: false,           null: false
    t.boolean  "feature_coupon",                                 default: false,           null: false
    t.boolean  "feature_to_basket_in_list",                      default: false,           null: false
    t.boolean  "feature_delivery_tracking",                      default: false,           null: false
    t.boolean  "feature_blog",                                   default: false,           null: false
    t.boolean  "feature_lookbook",                               default: false,           null: false
    t.boolean  "feature_notify_templates",                       default: false,           null: false
    t.boolean  "feature_client_cabinet",                         default: false,           null: false
    t.boolean  "feature_wishlist",                               default: false,           null: false
    t.boolean  "feature_multilanguage",                          default: false,           null: false
    t.boolean  "feature_delivery_service",                       default: false,           null: false
    t.boolean  "feature_moysklad",                               default: false,           null: false
    t.boolean  "feature_order_state",                            default: false,           null: false
    t.boolean  "feature_yandex_market",                          default: false,           null: false
    t.boolean  "feature_torg_mail",                              default: false,           null: false
    t.boolean  "feature_amocrm",                                 default: false,           null: false
    t.integer  "month_price_kopeks",                             default: 0,               null: false
    t.string   "month_price_currency",               limit: 255, default: "RUB",           null: false
    t.boolean  "is_show_in_choose",                              default: false,           null: false
    t.integer  "feature_max_products",                           default: 5,               null: false
    t.boolean  "feature_import",                                 default: false,           null: false
    t.boolean  "feature_slider",                                 default: false,           null: false
    t.boolean  "feature_convead",                                default: false,           null: false
    t.boolean  "feature_custom_css",                             default: false,           null: false
    t.boolean  "feature_domain",                                 default: false,           null: false
    t.boolean  "feature_instagram",                              default: false,           null: false
    t.boolean  "can_change",                                     default: false,           null: false
  end

  create_table "text_blocks", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "title",      limit: 255
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "text_blocks", ["product_id", "position"], name: "index_text_blocks_on_product_id_and_position", using: :btree
  add_index "text_blocks", ["product_id"], name: "index_text_blocks_on_product_id", using: :btree

  create_table "top_banners", force: :cascade do |t|
    t.integer  "vendor_id",            null: false
    t.text     "link_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "content_translations"
  end

  add_index "top_banners", ["vendor_id"], name: "index_top_banners_on_vendor_id", using: :btree

  create_table "translations", force: :cascade do |t|
    t.integer  "vendor_id",                  null: false
    t.string   "locale",         limit: 255, null: false
    t.string   "key",            limit: 255, null: false
    t.text     "value"
    t.text     "interpolations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["vendor_id", "locale", "key"], name: "index_translations_on_vendor_id_and_locale_and_key", using: :btree

  create_table "user_requests", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "phone",        limit: 255
    t.string   "email",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manager_id"
    t.integer  "vendor_id"
    t.text     "referer"
    t.text     "opts"
    t.integer  "state",                    default: 0, null: false
    t.string   "clean_phone",  limit: 255
    t.string   "remote_ip",    limit: 255
    t.datetime "deleted_at"
    t.string   "utm_source",   limit: 255
    t.string   "utm_medium",   limit: 255
    t.string   "utm_term",     limit: 255
    t.string   "utm_content",  limit: 255
    t.string   "utm_campaign", limit: 255
  end

  create_table "vendor_amo_crms", force: :cascade do |t|
    t.integer  "vendor_id",                                      null: false
    t.string   "login",               limit: 255
    t.string   "apikey",              limit: 255
    t.string   "url",                 limit: 255
    t.integer  "responsible_user_id"
    t.integer  "pipeline_id"
    t.string   "tags",                limit: 255
    t.boolean  "is_active",                       default: true, null: false
    t.text     "last_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_amo_crms", ["vendor_id"], name: "index_vendor_amo_crms_on_vendor_id", using: :btree

  create_table "vendor_analytics_days", force: :cascade do |t|
    t.integer  "vendor_id",                       null: false
    t.date     "date",                            null: false
    t.integer  "orders_count",        default: 0, null: false
    t.integer  "carts_count",         default: 0, null: false
    t.integer  "product_views_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_analytics_days", ["vendor_id", "date"], name: "index_vendor_analytics_days_on_vendor_id_and_date", unique: true, using: :btree
  add_index "vendor_analytics_days", ["vendor_id"], name: "index_vendor_analytics_days_on_vendor_id", using: :btree

  create_table "vendor_bells", force: :cascade do |t|
    t.integer  "vendor_id",                           null: false
    t.string   "key",        limit: 255,              null: false
    t.hstore   "options",                default: {}, null: false
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_deliveries", force: :cascade do |t|
    t.integer  "vendor_id",                                                    null: false
    t.string   "delivery_agent_type",              limit: 255,                 null: false
    t.integer  "position"
    t.boolean  "is_active",                                    default: true,  null: false
    t.integer  "price_kopeks",                                 default: 0,     null: false
    t.string   "price_currency",                   limit: 255, default: "RUB"
    t.string   "login",                            limit: 255
    t.string   "password",                         limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "free_delivery_threshold_kopeks"
    t.string   "free_delivery_threshold_currency", limit: 255, default: "RUB"
    t.integer  "auto_cancel_period_days",                      default: 5
    t.hstore   "title_translations"
    t.hstore   "description_translations"
    t.hstore   "city_title_translations"
  end

  add_index "vendor_deliveries", ["vendor_id", "position", "is_active"], name: "index_vendor_deliveries_on_vendor_id_and_position_and_is_active", using: :btree
  add_index "vendor_deliveries", ["vendor_id"], name: "index_vendor_deliveries_on_vendor_id", using: :btree

  create_table "vendor_jobs", force: :cascade do |t|
    t.integer  "vendor_id"
    t.integer  "state",                      default: 0,   null: false
    t.text     "result"
    t.string   "sidekiq_job_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",           limit: 255
    t.integer  "progress",                   default: 0,   null: false
    t.string   "asset",          limit: 255
    t.text     "parameters"
    t.integer  "total",                      default: 100, null: false
    t.integer  "current",                    default: 0,   null: false
    t.integer  "demo_vendor_id"
  end

  add_index "vendor_jobs", ["vendor_id", "state"], name: "index_vendor_jobs_on_vendor_id_and_state", using: :btree
  add_index "vendor_jobs", ["vendor_id"], name: "index_vendor_jobs_on_vendor_id", using: :btree

  create_table "vendor_payments", force: :cascade do |t|
    t.integer  "vendor_id",                                                null: false
    t.string   "payment_agent_type",           limit: 255,                 null: false
    t.integer  "position"
    t.boolean  "is_active",                                default: true,  null: false
    t.string   "w1_payment_id",                limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wmi_enabled_payment_methods",  limit: 255, default: [],    null: false, array: true
    t.string   "wmi_disabled_payment_methods", limit: 255, default: [],    null: false, array: true
    t.integer  "canceling_timeout_minutes",                default: 1440,  null: false
    t.string   "yandex_kassa_payment_method",  limit: 255
    t.hstore   "title_translations"
    t.hstore   "description_translations"
    t.string   "rbk_money_payment_method",     limit: 255
    t.boolean  "show_icon",                                default: false, null: false
  end

  add_index "vendor_payments", ["vendor_id", "position", "is_active"], name: "index_vendor_payments_on_vendor_id_and_position_and_is_active", using: :btree
  add_index "vendor_payments", ["vendor_id"], name: "index_vendor_payments_on_vendor_id", using: :btree

  create_table "vendor_product_analytics_days", force: :cascade do |t|
    t.integer  "vendor_id",                null: false
    t.integer  "product_id",               null: false
    t.date     "date",                     null: false
    t.integer  "orders_count", default: 0, null: false
    t.integer  "carts_count",  default: 0, null: false
    t.integer  "views_count",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_product_analytics_days", ["product_id"], name: "index_vendor_product_analytics_days_on_product_id", using: :btree
  add_index "vendor_product_analytics_days", ["vendor_id", "date", "product_id"], name: "vpad_uniq", unique: true, using: :btree
  add_index "vendor_product_analytics_days", ["vendor_id"], name: "index_vendor_product_analytics_days_on_vendor_id", using: :btree

  create_table "vendor_properties", force: :cascade do |t|
    t.string   "stock_title",               limit: 255
    t.string   "key",                       limit: 255,                      null: false
    t.integer  "vendor_id",                                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_used_in_product",                    default: false
    t.boolean  "is_used_in_item",                       default: true
    t.integer  "position_in_item",                      default: 0,          null: false
    t.integer  "position_in_product",                   default: 0,          null: false
    t.string   "ms_uuid",                   limit: 255
    t.string   "type",                      limit: 255, default: "Property", null: false
    t.datetime "deleted_at"
    t.string   "externalcode",              limit: 255
    t.datetime "stock_synced_at"
    t.text     "stock_dump"
    t.text     "description"
    t.boolean  "is_required",                           default: false
    t.integer  "dictionary_id"
    t.boolean  "is_active",                             default: true,       null: false
    t.text     "stock_description"
    t.boolean  "show_in_filter",                        default: true,       null: false
    t.boolean  "use_in_short_details",                  default: true,       null: false
    t.hstore   "custom_title_translations"
    t.hstore   "cached_title_translations"
  end

  add_index "vendor_properties", ["vendor_id", "externalcode"], name: "index_vendor_properties_on_vendor_id_and_externalcode", unique: true, using: :btree
  add_index "vendor_properties", ["vendor_id", "is_used_in_item"], name: "index_vendor_properties_on_vendor_id_and_is_used_in_item", using: :btree
  add_index "vendor_properties", ["vendor_id", "is_used_in_product"], name: "index_vendor_properties_on_vendor_id_and_is_used_in_product", using: :btree
  add_index "vendor_properties", ["vendor_id", "key"], name: "index_vendor_properties_on_vendor_id_and_key", unique: true, using: :btree
  add_index "vendor_properties", ["vendor_id", "ms_uuid"], name: "index_vendor_properties_on_vendor_id_and_ms_uuid", unique: true, using: :btree
  add_index "vendor_properties", ["vendor_id", "stock_title"], name: "index_vendor_properties_on_vendor_id_and_stock_title", using: :btree

  create_table "vendor_registrations", force: :cascade do |t|
    t.string   "email",               limit: 255
    t.string   "phone",               limit: 255
    t.string   "partner_coupon_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_selling_currencies", force: :cascade do |t|
    t.integer  "vendor_id",                                     null: false
    t.string   "currency_iso_code", limit: 255, default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_selling_currencies", ["vendor_id", "currency_iso_code"], name: "vendor_currencies", unique: true, using: :btree

  create_table "vendor_sessions", force: :cascade do |t|
    t.integer  "vendor_id",              null: false
    t.string   "session_id", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_sessions", ["vendor_id", "session_id"], name: "index_vendor_sessions_on_vendor_id_and_session_id", unique: true, using: :btree

  create_table "vendor_sms_log_entities", force: :cascade do |t|
    t.integer  "vendor_id"
    t.text     "message"
    t.string   "phones",     limit: 255,                              array: true
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sms_count",              default: 0,     null: false
    t.boolean  "is_success",             default: false, null: false
    t.boolean  "free",                   default: false, null: false
    t.string   "key",        limit: 255
  end

  add_index "vendor_sms_log_entities", ["vendor_id"], name: "index_vendor_sms_log_entities_on_vendor_id", using: :btree

  create_table "vendor_themes", force: :cascade do |t|
    t.integer  "vendor_id",                                                  null: false
    t.string   "custom_body_class",        limit: 255
    t.string   "theme_template_key",       limit: 255, default: "white",     null: false
    t.integer  "category_product_columns",             default: 3,           null: false
    t.text     "custom_style"
    t.string   "custom_style_format",      limit: 255,                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mstile_color",             limit: 255
    t.integer  "category_product_rows",                default: 3
    t.boolean  "category_filter_visible",              default: true,        null: false
    t.integer  "mainpage_product_rows",                default: 3,           null: false
    t.boolean  "is_welcome_ordered",                   default: true,        null: false
    t.text     "page_bg"
    t.string   "page_bg_color",            limit: 255, default: "#ffffff",   null: false
    t.string   "feed_bg_color",            limit: 255, default: "#ffffff",   null: false
    t.float    "feed_transparency",                    default: 0.0,         null: false
    t.string   "font_family",              limit: 255, default: "helvetica", null: false
    t.string   "font_color",               limit: 255, default: "#000000",   null: false
    t.string   "font_size",                limit: 255, default: "md",        null: false
    t.boolean  "mainpage_filter_visible",              default: true,        null: false
    t.integer  "mainpage_product_columns",             default: 3,           null: false
    t.string   "product_image_position",   limit: 255, default: "aside",     null: false
    t.boolean  "instagram_visible",                    default: true,        null: false
    t.boolean  "banner_visible",                       default: true,        null: false
    t.boolean  "slider_visible",                       default: true,        null: false
    t.string   "active_elements_color",    limit: 255, default: "#000000",   null: false
    t.boolean  "w1_widget_visible",                    default: true,        null: false
    t.string   "w1_widget_ptenabled",      limit: 255, default: ""
    t.boolean  "show_short_details",                   default: true,        null: false
    t.boolean  "show_similar_products",                default: true,        null: false
    t.boolean  "is_welcome_random",                    default: false,       null: false
    t.boolean  "show_cart_button_in_list",             default: true,        null: false
    t.boolean  "show_quantity_in_list",                default: false,       null: false
  end

  add_index "vendor_themes", ["vendor_id"], name: "index_vendor_themes_on_vendor_id", using: :btree

  create_table "vendor_walletones", force: :cascade do |t|
    t.integer  "vendor_id"
    t.string   "legal_form",         limit: 255, default: "unknown",      null: false
    t.integer  "branch_category_id"
    t.string   "title",              limit: 255
    t.string   "legal_country",      limit: 255
    t.string   "legal_title",        limit: 255
    t.string   "legal_tax_number",   limit: 255
    t.string   "legal_address",      limit: 255
    t.string   "legal_reg_number",   limit: 255
    t.string   "first_name",         limit: 255
    t.string   "middle_name",        limit: 255
    t.string   "last_name",          limit: 255
    t.string   "phone",              limit: 255
    t.string   "phone_confirmed",    limit: 255
    t.datetime "phone_confirmed_at"
    t.integer  "phone_operator_id"
    t.string   "email",              limit: 255
    t.string   "merchant_id",        limit: 255
    t.string   "merchant_sign_key",  limit: 255
    t.string   "merchant_token",     limit: 255
    t.string   "owner_user_id",      limit: 255
    t.string   "state",              limit: 255, default: "not_approved", null: false
    t.datetime "balance_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",                    default: 643,            null: false
  end

  add_index "vendor_walletones", ["vendor_id"], name: "index_vendor_walletones_on_vendor_id", using: :btree

  create_table "vendors", force: :cascade do |t|
    t.string   "name",                                  limit: 255,                                                 null: false
    t.string   "domain",                                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",                                   limit: 255,                                                 null: false
    t.string   "mobile_subject",                        limit: 255
    t.text     "mobile_description"
    t.integer  "minimal_price_kopeks",                               default: 0,                                    null: false
    t.string   "minimal_price_currency",                limit: 255
    t.string   "state",                                 limit: 255,  default: "new"
    t.string   "mobile_title",                          limit: 255,  default: "Доставка<br>пончиков"
    t.string   "mobile_logo",                           limit: 4096
    t.string   "mobile_footer",                         limit: 255,  default: "Выберите блюдо на заказ"
    t.string   "mobile_delivery",                       limit: 255,  default: "Доставка бесплатно от 500 руб."
    t.string   "mobile_empty_cart_alert",               limit: 255,  default: "Выберите из списка блюдо на заказ.", null: false
    t.integer  "city_id"
    t.string   "logo",                                  limit: 4096
    t.integer  "key_item_property_id"
    t.string   "google_login",                          limit: 255
    t.string   "google_password",                       limit: 255
    t.string   "google_import_spreadsheet_key",         limit: 255
    t.string   "google_analytics_tracking_id",          limit: 255
    t.string   "yandex_metrika_tracking_id",            limit: 255
    t.text     "custom_append_html"
    t.string   "subdomain",                             limit: 255
    t.string   "moysklad_login",                        limit: 255
    t.string   "moysklad_password",                     limit: 255
    t.string   "legal_form",                            limit: 255,  default: "unknown"
    t.boolean  "stock_auto_syncing",                                 default: false
    t.boolean  "is_stock_do_sync_categories",                        default: true
    t.datetime "stock_success_synced_at"
    t.string   "suggested_domain",                      limit: 255
    t.string   "currency_iso_code",                     limit: 255,  default: "RUB",                                null: false
    t.integer  "root_category_id"
    t.string   "support_email",                         limit: 255
    t.string   "instagram_user_id",                     limit: 255
    t.boolean  "sellable_infinity",                                  default: true,                                 null: false
    t.string   "domain_zone",                           limit: 255,  default: "kiiiosk.ru",                         null: false
    t.text     "custom_head_html"
    t.string   "checked_dashboard_items",               limit: 255,  default: [],                                   null: false, array: true
    t.integer  "welcome_category_id"
    t.text     "run_out_message"
    t.boolean  "autopublicate_goods_from_stock",                     default: true,                                 null: false
    t.integer  "default_import_category_id"
    t.boolean  "prefer_stock_category_when_syncing",                 default: true,                                 null: false
    t.integer  "package_category_id"
    t.boolean  "is_package_discounted",                              default: true
    t.integer  "manager_id"
    t.integer  "products_count",                                     default: 0,                                    null: false
    t.integer  "orders_count",                                       default: 0,                                    null: false
    t.boolean  "is_published",                                       default: true,                                 null: false
    t.text     "robots",                                             default: "User-agent: *"
    t.datetime "translations_updated_at"
    t.text     "not_published_text",                                 default: ""
    t.integer  "done_orders_count",                                  default: 0,                                    null: false
    t.text     "init_referer"
    t.text     "meta_title"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "h1",                                    limit: 255
    t.text     "custom_product_html"
    t.boolean  "has_auto_menu",                                      default: true,                                 null: false
    t.integer  "tariff_id"
    t.boolean  "show_filter_availability",                           default: false
    t.boolean  "show_filter_price_range",                            default: false
    t.string   "init_utm_source",                       limit: 255
    t.string   "init_utm_campaign",                     limit: 255
    t.string   "init_utm_medium",                       limit: 255
    t.string   "init_utm_term",                         limit: 255
    t.string   "init_utm_content",                      limit: 255
    t.boolean  "reserve_on_linked_stock",                            default: true,                                 null: false
    t.boolean  "is_stock_linked",                                    default: false,                                null: false
    t.boolean  "is_ordering_stock_linked_only"
    t.string   "cached_home_url",                       limit: 255,                                                 null: false
    t.integer  "vk_group_id"
    t.datetime "last_signed_at"
    t.datetime "last_order_at"
    t.datetime "last_success_order_at"
    t.datetime "last_payment_at"
    t.integer  "success_orders_count",                               default: 0,                                    null: false
    t.integer  "success_payments_count",                             default: 0,                                    null: false
    t.integer  "blog_posts_count",                                   default: 0,                                    null: false
    t.integer  "total_file_size",                       limit: 8,    default: 0
    t.integer  "total_orders_price_kopeks",             limit: 8,    default: 0,                                    null: false
    t.string   "total_orders_price_currency",           limit: 255,  default: "RUB",                                null: false
    t.integer  "total_success_orders_price_kopeks",     limit: 8,    default: 0,                                    null: false
    t.string   "total_success_orders_price_currency",   limit: 255,  default: "RUB",                                null: false
    t.datetime "products_updated_at"
    t.integer  "public_offer_page_id"
    t.integer  "clients_count",                                      default: 0,                                    null: false
    t.text     "analytics_js",                                       default: ""
    t.datetime "menu_updated_at"
    t.integer  "vk_export_period"
    t.datetime "vk_synced_at"
    t.string   "ms_sale_price_name",                    limit: 255,  default: "распродаж",                          null: false
    t.string   "last_utm_source",                       limit: 255
    t.string   "last_utm_campaign",                     limit: 255
    t.string   "last_utm_medium",                       limit: 255
    t.string   "last_utm_term",                         limit: 255
    t.string   "last_utm_content",                      limit: 255
    t.string   "last_referer",                          limit: 255
    t.boolean  "has_client_cabinet",                                 default: false,                                null: false
    t.boolean  "has_wishlists",                                      default: true,                                 null: false
    t.string   "convead_app_key",                       limit: 255
    t.integer  "selling_currencies_count",                           default: 0,                                    null: false
    t.text     "translations_dump"
    t.boolean  "moysklad_mirror_categories_tree",                    default: true,                                 null: false
    t.boolean  "tasty_exportable",                                   default: false,                                null: false
    t.string   "tasty_tlog_id",                         limit: 255
    t.string   "tasty_user_token",                      limit: 255
    t.string   "available_currencies",                  limit: 255,  default: [],                                   null: false, array: true
    t.string   "default_similar_products_mode",         limit: 255,  default: "auto",                               null: false
    t.string   "default_product_position",              limit: 255,  default: "last",                               null: false
    t.boolean  "clean_order_address",                                default: false,                                null: false
    t.boolean  "has_product_comments",                               default: false,                                null: false
    t.boolean  "pay_pal_enabled",                                    default: false
    t.string   "pay_pal_email",                         limit: 255
    t.string   "remote_ip",                             limit: 255
    t.string   "disqus_url",                            limit: 255
    t.text     "custom_after_content_html"
    t.boolean  "yandex_kassa_enabled",                               default: false
    t.string   "yandex_kassa_secret",                   limit: 255
    t.string   "yandex_kassa_shop_id",                  limit: 255
    t.string   "yandex_kassa_scid",                     limit: 255
    t.string   "default_locale",                        limit: 255,  default: "ru",                                 null: false
    t.string   "available_locales",                     limit: 255,  default: ["ru"],                               null: false, array: true
    t.boolean  "yandex_kassa_test_mode",                             default: false,                                null: false
    t.datetime "negative_balance_notified_at"
    t.boolean  "yandex_market_enabled",                              default: false,                                null: false
    t.string   "yandex_market_company",                 limit: 255
    t.boolean  "torg_mail_enabled",                                  default: false,                                null: false
    t.string   "torg_mail_company",                     limit: 255
    t.boolean  "is_external_link_kiosk_disabled",                    default: false,                                null: false
    t.date     "external_link_kiosk_next_pay_date"
    t.hstore   "title_translations"
    t.hstore   "contacts_translations"
    t.hstore   "pre_products_text_translations"
    t.hstore   "post_products_text_translations"
    t.boolean  "show_cart_button_in_list",                           default: false,                                null: false
    t.string   "instagram_client_id",                   limit: 255
    t.string   "instagram_client_secret",               limit: 255
    t.string   "instagram_access_token",                limit: 255
    t.boolean  "show_full_basket_count",                             default: false,                                null: false
    t.string   "rbk_money_eshop_id",                    limit: 255
    t.string   "rbk_money_secret",                      limit: 255
    t.integer  "next_month_tariff_id"
    t.string   "legal_entity",                          limit: 255
    t.boolean  "show_quantity_in_list",                              default: false,                                null: false
    t.integer  "amocrm_company_id"
    t.integer  "amocrm_lead_id"
    t.string   "visitor_uid",                           limit: 255
    t.boolean  "is_menu_top_desktop_sticky",                         default: false,                                null: false
    t.date     "paid_to"
    t.date     "working_to"
    t.datetime "not_enough_sms_money_notify_date"
    t.datetime "sms_money_limit_reached_notify_date"
    t.integer  "sms_money_limit_to_notify",                          default: 200,                                  null: false
    t.boolean  "is_order_comment_presence",                          default: false,                                null: false
    t.text     "footer_menu_middle_html"
    t.string   "instagram_username",                    limit: 255
    t.string   "partner_coupon_code",                   limit: 255
    t.integer  "partner_coupon_id"
    t.date     "partner_coupon_active_to"
    t.boolean  "show_header_buttons_in_cart",                        default: false,                                null: false
    t.boolean  "show_next_resource_in_list",                         default: false,                                null: false
    t.boolean  "show_subscription_email",                            default: false,                                null: false
    t.boolean  "convead_send_subscription_email",                    default: false,                                null: false
    t.boolean  "is_show_filter_toggle_button",                       default: false,                                null: false
    t.boolean  "is_pre_create",                                      default: false,                                null: false
    t.date     "shop_will_archive_notified_at"
    t.text     "archive_reason"
    t.date     "deleted_at"
    t.datetime "registration_at"
    t.datetime "first_billing_payment_at"
    t.integer  "first_billing_payment_amount_kopeks",                default: 0,                                    null: false
    t.string   "first_billing_payment_amount_currency", limit: 255,  default: "RUB",                                null: false
  end

  add_index "vendors", ["cached_home_url"], name: "index_vendors_on_cached_home_url", unique: true, using: :btree
  add_index "vendors", ["clients_count"], name: "index_vendors_on_clients_count", using: :btree
  add_index "vendors", ["domain"], name: "index_vendors_on_domain", unique: true, using: :btree
  add_index "vendors", ["key"], name: "index_vendors_on_key", unique: true, using: :btree
  add_index "vendors", ["manager_id"], name: "index_vendors_on_manager_id", using: :btree
  add_index "vendors", ["subdomain"], name: "index_vendors_on_subdomain", unique: true, using: :btree

  create_table "warehouses", force: :cascade do |t|
    t.string   "ms_uuid",           limit: 255
    t.text     "stock_dump"
    t.datetime "stock_synced_at"
    t.string   "externalcode",      limit: 255
    t.text     "stock_description"
    t.string   "name",              limit: 255,                null: false
    t.boolean  "is_active",                     default: true, null: false
    t.integer  "vendor_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.integer  "wishlist_id",                null: false
    t.string   "good_global_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishlist_items", ["wishlist_id", "good_global_id"], name: "index_wishlist_items_on_wishlist_id_and_good_global_id", unique: true, using: :btree
  add_index "wishlist_items", ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id", using: :btree

  create_table "wishlists", force: :cascade do |t|
    t.integer  "vendor_id",              null: false
    t.integer  "client_id"
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id", limit: 255
  end

  add_index "wishlists", ["client_id"], name: "index_wishlists_on_client_id", using: :btree
  add_index "wishlists", ["vendor_id", "client_id"], name: "index_wishlists_on_vendor_id_and_client_id", unique: true, using: :btree
  add_index "wishlists", ["vendor_id", "slug"], name: "index_wishlists_on_vendor_id_and_slug", unique: true, using: :btree
  add_index "wishlists", ["vendor_id"], name: "index_wishlists_on_vendor_id", using: :btree

  create_table "workflow_states", force: :cascade do |t|
    t.string   "name",                   limit: 255,                 null: false
    t.string   "color_hex",              limit: 255
    t.integer  "position",                           default: 0,     null: false
    t.string   "ms_workflow_state_uuid", limit: 255
    t.integer  "vendor_id",                                          null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "finite_state",           limit: 255, default: "new", null: false
    t.integer  "orders_count",                       default: 0,     null: false
  end

  add_index "workflow_states", ["vendor_id", "finite_state"], name: "index_workflow_states_on_vendor_id_and_finite_state", using: :btree
  add_index "workflow_states", ["vendor_id", "name"], name: "index_workflow_states_on_vendor_id_and_name", using: :btree
  add_index "workflow_states", ["vendor_id"], name: "index_workflow_states_on_vendor_id", using: :btree

  add_foreign_key "cart_items", "carts", name: "cart_items_cart_id_fk"
  add_foreign_key "carts", "vendors", name: "carts_vendor_id_fk"
  add_foreign_key "categories", "vendors", name: "categories_vendor_id_fk"
  add_foreign_key "client_emails", "clients", name: "client_emails_client_id_fk", on_delete: :cascade
  add_foreign_key "client_phones", "clients", name: "client_phones_client_id_fk", on_delete: :cascade
  add_foreign_key "clients", "orders", column: "last_order_id", name: "clients_last_order_id_fk"
  add_foreign_key "content_pages", "vendors", name: "content_pages_vendor_id_fk"
  add_foreign_key "dictionaries", "vendors", name: "dictionaries_vendor_id_fk"
  add_foreign_key "dictionary_entities", "dictionaries", name: "dictionary_entities_dictionary_id_fk"
  add_foreign_key "dictionary_entities", "vendors", name: "dictionary_entities_vendor_id_fk"
  add_foreign_key "members", "operators", name: "vendor_to_operators_operator_id_fk"
  add_foreign_key "members", "vendors", name: "vendor_to_operators_vendor_id_fk"
  add_foreign_key "openbill_accounts", "openbill_categories", column: "category_id", name: "openbill_accounts_category_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_categories", "openbill_categories", column: "parent_id", name: "openbill_categories_parent_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_invoices", "openbill_accounts", column: "destination_account_id", name: "openbill_invoices_destination_account_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_policies", "openbill_accounts", column: "from_account_id", name: "openbill_policies_from_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "to_account_id", name: "openbill_policies_to_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "from_category_id", name: "openbill_policies_from_category_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "to_category_id", name: "openbill_policies_to_category_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "from_account_id", name: "openbill_transactions_from_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "to_account_id", name: "openbill_transactions_to_account_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_transactions", column: "reverse_transaction_id", name: "reverse_transaction_foreign_key"
  add_foreign_key "openbill_webhook_logs", "openbill_transactions", column: "transaction_id", name: "openbill_webhook_logs_transaction_id_fkey", on_delete: :cascade
  add_foreign_key "order_conditions", "vendor_deliveries", name: "order_conditions_vendor_delivery_id_fk"
  add_foreign_key "order_conditions", "vendor_payments", name: "order_conditions_vendor_payment_id_fk"
  add_foreign_key "order_conditions", "vendors", name: "order_conditions_vendor_id_fk"
  add_foreign_key "order_conditions", "workflow_states", column: "enter_workflow_state_id", name: "order_conditions_enter_workflow_state_id_fk"
  add_foreign_key "order_items", "orders", name: "order_items_order_id_fk"
  add_foreign_key "order_log_entities", "operators", column: "author_id", name: "order_log_entities_author_id_fk"
  add_foreign_key "order_log_entities", "orders", name: "order_log_entities_order_id_fk"
  add_foreign_key "orders", "carts", name: "orders_cart_id_fk"
  add_foreign_key "orders", "cities", name: "orders_city_id_fk"
  add_foreign_key "orders", "coupons", name: "orders_coupon_id_fk"
  add_foreign_key "orders", "vendors", name: "orders_vendor_id_fk"
  add_foreign_key "payment_to_deliveries", "vendor_deliveries", name: "payment_to_deliveries_vendor_delivery_id_fk"
  add_foreign_key "payment_to_deliveries", "vendor_payments", name: "payment_to_deliveries_vendor_payment_id_fk"
  add_foreign_key "product_images", "products", name: "product_images_product_id_fk"
  add_foreign_key "product_images", "vendors", name: "product_images_vendor_id_fk"
  add_foreign_key "product_items", "products", name: "product_items_product_id_fk"
  add_foreign_key "product_items", "vendors", name: "product_items_vendor_id_fk"
  add_foreign_key "products", "products", column: "product_union_id", name: "products_product_union_id_fk"
  add_foreign_key "products", "vendors", name: "products_vendor_id_fk"
  add_foreign_key "slider_images", "vendors", name: "slider_images_vendor_id_fk"
  add_foreign_key "stock_importing_log_entities", "vendors", name: "stock_importing_log_entities_vendor_id_fk"
  add_foreign_key "vendor_bells", "vendors", name: "vendor_bells_vendor_id_fk", on_delete: :cascade
  add_foreign_key "vendor_properties", "dictionaries", name: "vendor_properties_dictionary_id_fk"
  add_foreign_key "vendor_properties", "vendors", name: "vendor_properties_vendor_id_fk"
  add_foreign_key "vendor_sessions", "vendors", name: "vendor_sessions_vendor_id_fk"
  add_foreign_key "vendor_walletones", "vendors", name: "vendor_walletones_vendor_id_fk"
  add_foreign_key "vendors", "admin_users", column: "manager_id", name: "vendors_manager_id_fk"
  add_foreign_key "vendors", "cities", name: "vendors_city_id_fk"
  add_foreign_key "vendors", "content_pages", column: "public_offer_page_id", name: "vendors_public_offer_page_id_fk", on_delete: :nullify
  add_foreign_key "vendors", "vendor_properties", column: "key_item_property_id", name: "vendors_key_item_property_id_fk"
  add_foreign_key "wishlist_items", "wishlists", name: "wishlist_items_wishlist_id_fk", on_delete: :cascade
  add_foreign_key "wishlists", "clients", name: "wishlists_client_id_fk", on_delete: :cascade
  add_foreign_key "wishlists", "vendors", name: "wishlists_vendor_id_fk", on_delete: :cascade
end
