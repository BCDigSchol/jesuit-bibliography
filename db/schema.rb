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

ActiveRecord::Schema.define(version: 2018_11_14_193127) do

  create_table "bibliographies", force: :cascade do |t|
    t.text "reference_type"
    t.text "year_published"
    t.text "title"
    t.text "title_secondary"
    t.text "place_published"
    t.text "publisher"
    t.text "volume"
    t.text "number_of_volumes"
    t.text "pages"
    t.text "section"
    t.text "title_tertiary"
    t.text "edition"
    t.text "date"
    t.text "type_of_work"
    t.text "reprint_edition"
    t.text "abstract"
    t.text "title_translated"
    t.text "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "volume_number"
    t.text "worldcat_url"
    t.text "secondary_url"
    t.text "leuven_url"
    t.text "multimedia_dimensions"
    t.text "multimedia_series"
    t.text "multimedia_type"
    t.text "multimedia_url"
    t.text "event_title"
    t.text "event_location"
    t.text "event_institution"
    t.text "event_date"
    t.text "event_panel_title"
    t.text "event_url"
    t.text "dissertation_university"
    t.text "dissertation_thesis_type"
    t.text "dissertation_university_url"
    t.text "number_of_pages"
  end

  create_table "bibliography_entities", force: :cascade do |t|
    t.integer "entity_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_entities_on_bibliography_id"
    t.index ["entity_id"], name: "index_bibliography_entities_on_entity_id"
  end

  create_table "bibliography_locations", force: :cascade do |t|
    t.integer "location_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_locations_on_bibliography_id"
    t.index ["location_id"], name: "index_bibliography_locations_on_location_id"
  end

  create_table "bibliography_periods", force: :cascade do |t|
    t.integer "period_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_periods_on_bibliography_id"
    t.index ["period_id"], name: "index_bibliography_periods_on_period_id"
  end

  create_table "bibliography_subjects", force: :cascade do |t|
    t.integer "subject_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_subjects_on_bibliography_id"
    t.index ["subject_id"], name: "index_bibliography_subjects_on_subject_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "citations", force: :cascade do |t|
    t.text "display_name"
    t.text "surname"
    t.text "middlename"
    t.text "forename"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "editor_id"
    t.integer "book_editor_id"
    t.integer "author_of_review_id"
    t.integer "reviewed_author_id"
    t.integer "translator_id"
    t.integer "performer_id"
    t.integer "translated_author_id"
    t.index ["author_id"], name: "index_citations_on_author_id"
    t.index ["author_of_review_id"], name: "index_citations_on_author_of_review_id"
    t.index ["book_editor_id"], name: "index_citations_on_book_editor_id"
    t.index ["editor_id"], name: "index_citations_on_editor_id"
    t.index ["performer_id"], name: "index_citations_on_performer_id"
    t.index ["reviewed_author_id"], name: "index_citations_on_reviewed_author_id"
    t.index ["translated_author_id"], name: "index_citations_on_translated_author_id"
    t.index ["translator_id"], name: "index_citations_on_translator_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "commenter"
    t.text "body"
    t.text "comment_type"
    t.boolean "make_public"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_comments_on_bibliography_id"
  end

  create_table "entities", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.text "display_name"
    t.text "birth_date"
    t.text "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periods", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "standard_identifiers", force: :cascade do |t|
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "isbn_id"
    t.integer "issn_id"
    t.integer "doi_id"
    t.index ["doi_id"], name: "index_standard_identifiers_on_doi_id"
    t.index ["isbn_id"], name: "index_standard_identifiers_on_isbn_id"
    t.index ["issn_id"], name: "index_standard_identifiers_on_issn_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false
    t.boolean "admin_role", default: false
    t.boolean "collaborator_role", default: false
    t.boolean "editor_role", default: false
    t.boolean "user_role", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
