ActiveRecord::Schema.define(version: 2020_09_18_020819) do

  create_table "budgets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "total_budget", default: 0.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "content", null: false
    t.float "amount_income", default: 0.0, null: false
    t.bigint "user_id", null: false
    t.bigint "budget_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["budget_id"], name: "index_incomes_on_budget_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "content", null: false
    t.boolean "is_viewed", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "content", null: false
    t.float "amount_spent", default: 0.0, null: false
    t.string "paider", null: false
    t.bigint "request_id", null: false
    t.bigint "budget_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["budget_id"], name: "index_payments_on_budget_id"
    t.index ["request_id"], name: "index_payments_on_request_id"
  end

  create_table "request_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "amount", default: 0.0, null: false
    t.text "content", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_request_details_on_request_id"
  end

  create_table "requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "content", null: false
    t.text "reason", null: false
    t.float "total_amount", default: 0.0, null: false
    t.string "approver"
    t.integer "status", default: 1, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", null: false
    t.string "avatar"
    t.string "password_digest"
    t.integer "role", default: 2, null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email"
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  add_foreign_key "incomes", "budgets"
  add_foreign_key "incomes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "budgets"
  add_foreign_key "payments", "requests"
  add_foreign_key "request_details", "requests"
  add_foreign_key "requests", "users"
  add_foreign_key "users", "groups"
end
