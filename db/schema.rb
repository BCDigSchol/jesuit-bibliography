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

ActiveRecord::Schema.define(version: 2019_01_14_022709) do

  create_table "author_of_reviews", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_author_of_reviews_on_bibliography_id"
    t.index ["person_id"], name: "index_author_of_reviews_on_person_id"
  end

  create_table "authors", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_authors_on_bibliography_id"
    t.index ["person_id"], name: "index_authors_on_person_id"
  end

  create_table "bibliographies", force: :cascade do |t|
    t.text "reference_type"
    t.text "year_published"
    t.text "title"
    t.text "title_secondary"
    t.text "volume"
    t.text "number_of_volumes"
    t.text "edition"
    t.text "date"
    t.text "reprint_edition"
    t.text "abstract"
    t.text "translated_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "volume_number"
    t.text "multimedia_dimensions"
    t.text "multimedia_type"
    t.text "event_title"
    t.text "event_location"
    t.text "event_institution"
    t.text "event_date"
    t.text "event_panel_title"
    t.text "dissertation_thesis_type"
    t.text "number_of_pages"
    t.text "journal_title"
    t.text "issue"
    t.text "page_range"
    t.text "epub_date"
    t.text "chapter_number"
    t.text "book_title"
    t.text "title_of_review"
    t.text "chapter_title"
    t.text "display_title"
    t.text "display_year"
    t.text "display_author"
    t.text "paper_title"
    t.boolean "published"
    t.text "status"
    t.text "created_by"
    t.text "modified_by"
  end

  create_table "bibliography_entities", force: :cascade do |t|
    t.integer "entity_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_entities_on_bibliography_id"
    t.index ["entity_id"], name: "index_bibliography_entities_on_entity_id"
  end

  create_table "bibliography_journals", force: :cascade do |t|
    t.integer "journal_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_journals_on_bibliography_id"
    t.index ["journal_id"], name: "index_bibliography_journals_on_journal_id"
  end

  create_table "bibliography_languages", force: :cascade do |t|
    t.integer "language_id"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_bibliography_languages_on_bibliography_id"
    t.index ["language_id"], name: "index_bibliography_languages_on_language_id"
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

  create_table "book_editors", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_book_editors_on_bibliography_id"
    t.index ["person_id"], name: "index_book_editors_on_person_id"
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

  create_table "comments", force: :cascade do |t|
    t.text "commenter"
    t.text "body"
    t.text "comment_type"
    t.boolean "make_public"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "created_by"
    t.text "modified_by"
    t.index ["bibliography_id"], name: "index_comments_on_bibliography_id"
  end

  create_table "dissertation_universities", force: :cascade do |t|
    t.text "name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_dissertation_universities_on_bibliography_id"
  end

  create_table "editors", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_editors_on_bibliography_id"
    t.index ["person_id"], name: "index_editors_on_person_id"
  end

  create_table "entities", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.text "display_name"
    t.text "birth_date"
    t.text "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "created_by"
    t.text "modified_by"
  end

  create_table "entity_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_entity_suggestions_on_bibliography_id"
  end

  create_table "journal_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_journal_suggestions_on_bibliography_id"
  end

  create_table "journals", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.text "display_name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_journals_on_bibliography_id"
  end

  create_table "language_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_language_suggestions_on_bibliography_id"
  end

  create_table "languages", force: :cascade do |t|
    t.text "name"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sort_name"
    t.text "created_by"
    t.text "modified_by"
    t.index ["bibliography_id"], name: "index_languages_on_bibliography_id"
  end

  create_table "location_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_location_suggestions_on_bibliography_id"
  end

  create_table "locations", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "created_by"
    t.text "modified_by"
  end

  create_table "people", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.text "display_name"
    t.text "surname"
    t.text "middlename"
    t.text "forename"
    t.text "title"
    t.text "created_by"
    t.text "modified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performers", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_performers_on_bibliography_id"
    t.index ["person_id"], name: "index_performers_on_person_id"
  end

  create_table "period_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_period_suggestions_on_bibliography_id"
  end

  create_table "periods", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "created_by"
    t.text "modified_by"
  end

  create_table "person_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "field_name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_person_suggestions_on_bibliography_id"
  end

  create_table "publish_places", force: :cascade do |t|
    t.text "name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_publish_places_on_bibliography_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.text "name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_publishers_on_bibliography_id"
  end

  create_table "reviewed_components", force: :cascade do |t|
    t.text "reviewed_author"
    t.text "reviewed_title"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reviewed_translator"
    t.text "reviewed_editor"
    t.index ["bibliography_id"], name: "index_reviewed_components_on_bibliography_id"
  end

  create_table "searches", force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "series_multimedia", force: :cascade do |t|
    t.text "name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_series_multimedia_on_bibliography_id"
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

  create_table "subject_suggestions", force: :cascade do |t|
    t.text "name"
    t.text "note"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_subject_suggestions_on_bibliography_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.text "name"
    t.text "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "created_by"
    t.text "modified_by"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.text "created_by"
    t.text "modified_by"
    t.integer "bibliography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_tags_on_bibliography_id"
  end

  create_table "translated_authors", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_translated_authors_on_bibliography_id"
    t.index ["person_id"], name: "index_translated_authors_on_person_id"
  end

  create_table "translators", force: :cascade do |t|
    t.integer "bibliography_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bibliography_id"], name: "index_translators_on_bibliography_id"
    t.index ["person_id"], name: "index_translators_on_person_id"
  end

  create_table "urls", force: :cascade do |t|
    t.text "link"
    t.integer "worldcat_url_id"
    t.integer "publisher_url_id"
    t.integer "leuven_url_id"
    t.integer "multimedia_url_id"
    t.integer "event_url_id"
    t.integer "dissertation_university_url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dissertation_university_url_id"], name: "index_urls_on_dissertation_university_url_id"
    t.index ["event_url_id"], name: "index_urls_on_event_url_id"
    t.index ["leuven_url_id"], name: "index_urls_on_leuven_url_id"
    t.index ["multimedia_url_id"], name: "index_urls_on_multimedia_url_id"
    t.index ["publisher_url_id"], name: "index_urls_on_publisher_url_id"
    t.index ["worldcat_url_id"], name: "index_urls_on_worldcat_url_id"
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
    t.boolean "associate_editor_role", default: false
    t.boolean "assistant_editor_role", default: false
    t.boolean "correspondent_role", default: false
    t.text "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
