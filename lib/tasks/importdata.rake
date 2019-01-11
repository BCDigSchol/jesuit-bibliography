require 'csv'
require 'progress_bar'

bar = ProgressBar.new

CREATED_BY_USER = "admin@test.com"

# find strings delimited by single or double pipe characters
PIPE_DELIMITER_REGEX = /[|]+/

def import_logger
    @import_logger ||= Logger.new("#{Rails.root}/log/import_bibs.log")
end

namespace :importdata do

    desc "Destroy all Bibliography records"
    task clear_all: :environment do
        bar = ProgressBar.new(16)
        puts "Clearing all existing Bib records..."
        import_logger.info("Clearing all existing Bibliography records")
        Bibliography.destroy_all
        bar.increment!
        StandardIdentifier.destroy_all
        bar.increment!
        Comment.destroy_all
        bar.increment!
        Location.destroy_all
        bar.increment!
        Period.destroy_all
        bar.increment!
        Subject.destroy_all
        bar.increment!
        Entity.destroy_all
        bar.increment!
        Person.destroy_all
        bar.increment!
        Author.destroy_all
        bar.increment!
        Editor.destroy_all
        bar.increment!
        BookEditor.destroy_all
        bar.increment!
        AuthorOfReview.destroy_all
        bar.increment!
        Translator.destroy_all
        bar.increment!
        Performer.destroy_all
        bar.increment!
        TranslatedAuthor.destroy_all
        bar.increment!
        Language.destroy_all
        bar.increment!
        puts "Task completed.\n\n"
    end

    desc "Run all importdata tasks"
    task :all => [:clear_all, :books, :book_chapters, :book_reviews, :journal_articles, :dissertations, :conference_papers, :multimedia]

    desc "Import test books"
    task books: :environment do

        @format = "Book"

        puts "Starting #{@format}s import"
        import_logger.info("Starting #{@format}s import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'books.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            #break if item_count >= 300

            # Reference Type,Author,Year,Title,Place Published,Publisher,Volume,Number of Volumes,Number of Pages,Editor,
            # 0              1      2    3     4               5         6      7                 8               9
            #
            # Edition,Translator,ISBN,DOI,Reprint Edition,WorldCat URL,Publisher URL,Leuven URL,When,What,
            # 10      11         12   13  14              15           16            17         18   19
            #
            # Where,Who,Abstract,Notes,Notes to Editors,Translated Author,Translated Title,Language,Editing Tags
            # 20    21  22       23    24               25                26               27       28

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.title = row[3]
            @bib.display_title = row[3]
            #@bib.place_published = row[4]
            #@bib.publisher = row[5]
            @bib.volume = row[6]
            @bib.number_of_volumes = row[7]
            @bib.number_of_pages = row[8]
            #@bib.editor = row[9]
            @bib.edition = row[10]
            #@bib.translator = row[11]
            #@bib.isbn = row[12]
            #@bib.doi = row[13]
            @bib.reprint_edition = row[14]
            #@bib.worldcat_url = row[15]
            #@bib.publisher_url = row[16]
            #@bib.leuven_url = row[17]
            #@bib.when_subject = row[18]
            #@bib.what_subject = row[19]
            #@bib.where_subject = row[20]
            #@bib.who_subject = row[21]
            #@bib.abstract = row[22]
            #@bib.notes = row[23]
            #@bib.notes_to_editor = row[24]
            #@bib.translated_author = row[25]
            @bib.translated_title = row[26]
            #@bib.languages = row[27]
            #@bib.tags = row[28]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            elsif row[9]
                @bib.display_author = row[9]
            end

            # Abstract
            import_add_abstract(@bib, row[22])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.title}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Places Published
            import_add_places_published(@bib, row[4])

            # Publishers
            import_add_publishers(@bib, row[5])

            # Editors
            import_add_editors(@bib, row[9])

            # Translators
            import_add_translators(@bib, row[11])

            # ISBNs
            import_add_isbns(@bib, row[12])

            # DOIs
            import_add_dois(@bib, row[13])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[15])

            # Publisher URLs
            import_add_publisher_urls(@bib, row[16])

            # Leuven URLs/Other Links
            import_add_leuven_urls(@bib, row[17])

            # Periods/Centuries
            import_add_periods(@bib, row[18])

            # Subjects
            import_add_subjects(@bib, row[19])

            # Locations
            import_add_locations(@bib, row[20])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[21])

            # Notes -- Note
            import_add_notes(@bib, row[23])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[24])

            # Translated Authors
            import_add_translated_authors(@bib, row[25])

            # Languages
            import_add_languages(@bib, row[27])

            # Tags
            import_add_tags(@bib, row[28])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test book chapters"
    task book_chapters: :environment do

        @format = "Book Chapter"

        puts "Starting #{@format} import"
        import_logger.info("Starting #{@format} import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'book_chapters.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Chapter Title,Book Editor,Book Title,Place Published,Publisher,Volume,Number of Volumes,
            # 0              1      2    3             4           5          6               7         8      9
            #
            # Page Range,Chapter Number,Edition,Translator,ISBN,DOI,Reprint Edition,WorldCat URL,Publisher URL,Leuven URL,	
            # 10         11             12      13         14   15  16               17          18            19
            #
            # When,What,Where,Who,Abstract,Notes,Notes to Editors,Translated Author,Translated Title,Language
            # 20   21   22    23  24       25    26               27                28               29
            #
            # Editing Tags
            # 30

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.chapter_title = row[3]
            @bib.display_title = row[3]
            #@bib.book_editor = row[4]
            @bib.book_title = row[5]
            #@bib.place_published = row[6]
            #@bib.publisher = row[7]
            @bib.volume = row[8]
            @bib.number_of_volumes = row[9]
            @bib.page_range = row[10]
            @bib.chapter_number = row[11]
            @bib.edition = row[12]
            #@bib.translator = row[13]
            #@bib.isbn = row[14]
            #@bib.doi = row[15]
            @bib.reprint_edition = row[16]
            #@bib.worldcat_url = row[17]
            #@bib.publisher_url = row[18]
            #@bib.leuven_url = row[19]
            #@bib.when_subject = row[20]
            #@bib.what_subject = row[21]
            #@bib.where_subject = row[22]
            #@bib.who_subject = row[23]
            #@bib.abstract = row[24]
            #@bib.notes = row[25]
            #@bib.notes_to_editor = row[26]
            #@bib.translated_author = row[27]
            @bib.translated_title = row[28]
            #@bib.languages = row[29]
            #@bib.tags = row[30]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[24])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.chapter_title}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Book Editors
            import_book_editors(@bib, row[4])

            # Places Published
            import_add_places_published(@bib, row[6])

            # Publishers
            import_add_publishers(@bib, row[7])

            # Translators
            import_add_translators(@bib, row[13])

            # ISBNs
            import_add_isbns(@bib, row[14])

            # DOIs
            import_add_dois(@bib, row[15])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[17])

            # Publisher URLs
            import_add_publisher_urls(@bib, row[18])

            # Leuven URLs/Other Links
            import_add_leuven_urls(@bib, row[19])

            # Periods/Centuries
            import_add_periods(@bib, row[20])

            # Subjects
            import_add_subjects(@bib, row[21])

            # Locations
            import_add_locations(@bib, row[22])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[23])

            # Notes -- Note
            import_add_notes(@bib, row[25])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[26])

            # Translated Authors
            import_add_translated_authors(@bib, row[27])

            # Languages
            import_add_languages(@bib, row[29])

            # Tags
            import_add_tags(@bib, row[30])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test book reviews"
    task book_reviews: :environment do

        @format = "Book Review"

        puts "Starting #{@format}s import"
        import_logger.info("Starting #{@format}s import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'book_reviews.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author of Review,Year,Title of Review,Title of Journal,Volume,Issue,Page Range,Reviewed Author,Reviewed Title,
            # 0              1                2    3               4                5      6     7          8               9
            #
            # Epub Date,Date,ISSN,DOI,WorldCat URL,Publisher URL,Leuven URL,When,What,Where,
            # 10        11   12  13   14           15            16         17   18   19
            #
            # Who,Abstract,Notes,Notes to Editors,Translated Author,Translated Title,Language,Editing Tags
            # 20  21       22    23               24                25               26       27

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author_of_review = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.title_of_review = row[3]
            @bib.display_title = row[3]
            #@bib.journal_title = row[4]
            @bib.volume = row[5]
            @bib.issue = row[6]
            @bib.page_range = row[7]
            #@bib.reviewed_author = row[8]
            #@bib.reviewed_title = row[9]
            @bib.epub_date = row[10]
            @bib.date = row[11]
            #@bib.issn = row[12]
            #@bib.doi = row[13]
            #@bib.worldcat_url = row[14]
            #@bib.publisher_url = row[15]
            #@bib.leuven_url = row[16]
            #@bib.when_subject = row[17]
            #@bib.what_subject = row[18]
            #@bib.where_subject = row[19]
            #@bib.who_subject = row[20]
            #@bib.abstract = row[21]
            #@bib.notes = row[22]
            #@bib.notes_to_editor = row[23]
            #@bib.translated_author = row[24]
            @bib.translated_title = row[25]
            #@bib.languages = row[26]
            #@bib.tags = row[27]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[21])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.title_of_review}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Author of Reviews
            import_author_of_reviews(@bib, row[1])

            # Journal title
            import_add_journal_title(@bib, row[4])

            # Reviewed Title/Author
            # combine both fields into Reviewed_component record object
            if row[8] or row[9]
                @bib.reviewed_components << ReviewedComponent.new(reviewed_author: row[8], reviewed_title: row[9])
            end

            # ISSNs
            import_add_issns(@bib, row[12])

            # DOIs
            import_add_dois(@bib, row[13])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[14])

            # Publisher URLs
            import_add_publisher_urls(@bib, row[15])

            # Leuven URLs/Other Links
            import_add_leuven_urls(@bib, row[16])

            # Periods/Centuries
            import_add_periods(@bib, row[17])

            # Subjects
            import_add_subjects(@bib, row[18])

            # Locations
            import_add_locations(@bib, row[19])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[20])

            # Notes -- Note
            import_add_notes(@bib, row[22])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[23])

            # Translated Authors
            import_add_translated_authors(@bib, row[24])

            # Languages
            import_add_languages(@bib, row[26])

            # Tags
            import_add_tags(@bib, row[27])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test journal articles"
    task journal_articles: :environment do

        @format = "Journal Article"

        puts "Starting #{@format}s import"
        import_logger.info("Starting #{@format}s import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'journal_articles.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Title,Title of Journal,Volume,Issue,Page Range,Epub Date,Date,
            # 0              1      2    3     4                5      6     7          8         9
            #
            # ISSN,DOI,WorldCat URL,Publisher URL,Leuven URL,When,What,Where,Who,Abstract,
            # 10   11  12           13            14         15   16   17    18  19
            #
            # Notes,Notes to Editors,Translated Author,Translated Title,Language,Editing Tags
            # 20   21                22                23               24       25


            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.authors = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.title = row[3]
            @bib.display_title = row[3]
            #@bib.journal_title = row[4]
            @bib.volume = row[5]
            @bib.issue = row[6]
            @bib.page_range = row[7]
            @bib.epub_date = row[8]
            @bib.date = row[9]
            #@bib.issn = row[10]
            #@bib.doi = row[11]
            #@bib.worldcat_url = row[12]
            #@bib.publisher_url = row[13]
            #@bib.leuven_url = row[14]
            #@bib.when_subject = row[15]
            #@bib.what_subject = row[16]
            #@bib.where_subject = row[17]
            #@bib.who_subject = row[18]
            #@bib.abstract = row[19]
            #@bib.notes = row[20]
            #@bib.notes_to_editor = row[21]
            #@bib.translated_author = row[22]
            @bib.translated_title = row[23]
            #@bib.languages = row[24]
            #@bib.tags = tag[25]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[19])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.title_of_review}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Journal title
            import_add_journal_title(@bib, row[4])

            # ISSNs
            import_add_issns(@bib, row[10])

            # DOIs
            import_add_dois(@bib, row[11])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[12])

            # Publisher URLs
            import_add_publisher_urls(@bib, row[13])

            # Leuven URLs/Other Links
            import_add_leuven_urls(@bib, row[14])

            # Periods/Centuries
            import_add_periods(@bib, row[15])

            # Subjects
            import_add_subjects(@bib, row[16])

            # Locations
            import_add_locations(@bib, row[17])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[18])

            # Notes -- Note
            import_add_notes(@bib, row[20])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[21])

            # Translated Authors
            import_add_translated_authors(@bib, row[22])

            # Languages
            import_add_languages(@bib, row[24])

            # Tags
            import_add_tags(@bib, row[25])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test dissertations"
    task dissertations: :environment do

        @format = "Dissertation"

        puts "Starting #{@format}s import"
        import_logger.info("Starting #{@format}s import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'dissertations.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Title,Place Published,University,Number of Pages,Thesis Type,ISBN,WorldCat URL,
            # 0              1      2    3     4               5         6                7           8    9
            #
            # University URL,Leuven URL,When,What,Where,Who,Abstract,Notes,Notes to Editors,Language
            # 10             11         12   13  14     15  16       17    18               19
            #
            # Editing Tags
            # 20

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.title = row[3]
            @bib.display_title = row[3]
            #@bib.place_published = row[4]
            #@bib.dissertation_university = row[5]
            @bib.number_of_volumes = row[6]
            @bib.dissertation_thesis_type = row[7]
            #@bib.isbn = row[8]
            #@bib.worldcat_url = row[9]
            #@bib.dissertation_university_url = row[10]
            #@bib.leuven_url = row[11]
            #@bib.when_subject = row[12]
            #@bib.what_subject = row[13]
            #@bib.where_subject = row[14]
            #@bib.who_subject = row[15]
            #@bib.abstract = row[16]
            #@bib.notes = row[17]
            #@bib.notes_to_editor = row[18]
            #@bib.languages = row[19]
            #@bib.tags = row[20]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[16])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.title}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Places Published
            import_add_places_published(@bib, row[4])

            # Universities
            import_add_dissertation_universities(@bib, row[5])

            # ISBNs
            import_add_isbns(@bib, row[8])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[9])

            # Dissertation University  URLs
            import_dissertation_university_urls(@bib, row[10])

            # Leuven URLs
            import_add_leuven_urls(@bib, row[11])

            # Periods/Centuries
            import_add_periods(@bib, row[12])

            # Subjects
            import_add_subjects(@bib, row[13])

            # Locations
            import_add_locations(@bib, row[14])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[15])

            # Notes -- Note
            import_add_notes(@bib, row[17])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[18])

            # Languages
            import_add_languages(@bib, row[19])

            # Tags
            import_add_tags(@bib, row[20])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test conference papers"
    task conference_papers: :environment do

        @format = "Conference Paper"

        puts "Starting #{@format} import"
        import_logger.info("Starting #{@format} import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'conference_papers.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Paper Title,Event Title,Event City/Country,Event Institution,Event Date,Panel Title,Event URL,
            # 0              1      2    3           4           5                  6                 7          8           9
            #
            # When,What,Where,Who,Abstract,Notes,Notes to Editors,Language,Editing Tags
            # 10   11   12   13   14       15    16               17       18

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.paper_title = row[3]
            @bib.display_title = row[3]
            @bib.event_title = row[4]
            @bib.event_location = row[5]
            @bib.event_institution = row[6]
            @bib.event_date = row[7]
            @bib.event_panel_title = row[8]
            #@bib.event_url = row[9]
            #@bib.when_subject = row[10]
            #@bib.what_subject = row[11]
            #@bib.where_subject = row[12]
            #@bib.who_subject = row[13]
            #@bib.abstract = row[14]
            #@bib.notes = row[15]
            #@bib.notes_to_editor = row[16]
            #@bib.languages = row[17]
            #@bib.tags = row[18]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[14])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.chapter_title}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Event URLs
            import_add_event_urls(@bib, row[9])

            # Periods/Centuries
            import_add_periods(@bib, row[10])

            # Subjects
            import_add_subjects(@bib, row[11])

            # Locations
            import_add_locations(@bib, row[12])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[13])

            # Notes -- Note
            import_add_notes(@bib, row[15])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[16])

            # Languages
            import_add_languages(@bib, row[17])

            # Tags
            import_add_tags(@bib, row[18])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    desc "Import test multimedia"
    task multimedia: :environment do

        @format = "Multimedia"

        puts "Starting #{@format}s import"
        import_logger.info("Starting #{@format} import")

        item_count = 0
        start = Time.now
        file = select_import_home_path + 'multimedia.csv'
        total_lines = CSV.read(file, headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach(file, 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Title,Series,Place Published,Publisher,Type of Media,Performers,ISBN,
            # 0              1      2    3     4      5               6         7             8          9
            #
            # WorldCat URL,URL,Size/Length,When,What,Where,Who,Abstract,Notes,Notes to Editors,
            # 10           11  12          13   14   15    16  17       18    19
            #
            # Language,Editing Tags
            # 20       21

            @bib = Bibliography.new

            @bib.published = true
            @bib.status = "published"
            @bib.created_by = CREATED_BY_USER

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            #@bib.display_author = row[1]
            @bib.year_published = row[2]
            @bib.display_year = row[2]
            @bib.title = row[3]
            @bib.display_title = row[3]
            #@bib.multimedia_series = row[4]
            #@bib.place_published = row[5]
            #@bib.publisher = row[6]
            @bib.multimedia_type = row[7]
            #@bib.performers = row[8]
            #@bib.isbn = row[9]
            #@bib.worldcat_url = row[10]
            #@bib.multimedia_url = row[11]
            @bib.multimedia_dimensions = row[12]
            #@bib.when_subject = row[13]
            #@bib.what_subject = row[14]
            #@bib.where_subject = row[15]
            #@bib.who_subject = row[16]
            #@bib.abstract = row[17]
            #@bib.notes = row[18]
            #@bib.notes_to_editor = row[19]
            #@bib.languages = row[20]
            #@bib.tags = row[21]

            # Display Authors
            if row[1]
                @bib.display_author = row[1]
            end

            # Abstract
            import_add_abstract(@bib, row[17])

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: #{@format}")
            import_logger.info("  title: #{@bib.title}")
            import_logger.info("  year: #{@bib.year_published}")
            import_logger.info("  abstract: #{@bib.abstract}")
            
            # Authors
            import_add_authors(@bib, row[1])

            # Multimedia Series
            import_series_multimedium(@bib, row[4])

            # Places Published
            import_add_places_published(@bib, row[5])

            # Publishers
            import_add_publishers(@bib, row[6])

            # Performers
            import_add_performers(@bib, row[8])

            # ISBNs
            import_add_isbns(@bib, row[9])

            # Worldcat URLs
            import_add_worldcat_urls(@bib, row[10])

            # Multimedia URLs
            import_add_multimedia_urls(@bib, row[11])

            # Periods/Centuries
            import_add_periods(@bib, row[13])

            # Subjects
            import_add_subjects(@bib, row[14])

            # Locations
            import_add_locations(@bib, row[15])

            # Entities/Jesuits
            import_add_jesuits(@bib, row[16])

            # Notes -- Note
            import_add_notes(@bib, row[18])

            # Notes -- Note to editor
            import_add_notes_to_editor(@bib, row[19])

            # Languages
            import_add_languages(@bib, row[20])

            # Tags
            import_add_tags(@bib, row[21])

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} #{@format} records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} #{@format} records in #{diff} seconds")
    end

    # look at the RAILS_ENV variable and select the appropriate import file location
    def select_import_home_path
        # default path for RAILS_ENV=development
        path = "db/imports/"

        rails_env = ENV['RAILS_ENV'] || nil

        # check if RAILS_ENV is set
        if rails_env.nil?
            puts "\n\nRAILS_ENV is not set in this shell. Defaulting to 'production'.\n\n"
        end

        puts "Found RAILS_ENV=#{rails_env}"

        # if this is the production server then look for the import files
        # in the rails user's home directory
        if rails_env == "production"
            path = "#{Dir.home}/imports/"
        end

        puts "Using import file path: '#{path}'"

        path
    end

    # Authors
    def import_add_authors(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Author: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.authors << Author.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Book Editors
    def import_book_editors(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Book Editor: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.book_editors << BookEditor.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Author of Reviews
    def import_author_of_reviews(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Author of Review: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.author_of_reviews << AuthorOfReview.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Multimedia Series
    def import_series_multimedium(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Multimedia Series: #{v}")
                @bib.series_multimedium << SeriesMultimedium.new(name: v)
            end
        end
    end

    # Journal Title
    def import_add_journal_title(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Journal Title: #{v}")
                @bib.journals << Journal.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Places Published
    def import_add_places_published(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Place Published: #{v}")
                @bib.publish_places << PublishPlace.new(name: v)
            end
        end
    end

    # Publishers
    def import_add_publishers(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Publisher: #{v}")
                @bib.publishers << Publisher.new(name: v)
            end
        end
    end

    # Editors
    def import_add_editors(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Editor: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.editors << Editor.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Translators
    def import_add_translators(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Translator: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.translators << Translator.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Performers
    def import_add_performers(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Performer: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.performers << Performer.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Universities
    def import_add_dissertation_universities(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding University: #{v}")
                @bib.dissertation_universities << DissertationUniversity.new(name: v)
            end
        end
    end

    # ISBNs
    def import_add_isbns(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding ISBN: #{v}")
                @bib.isbns << StandardIdentifier.new(value: v)
            end
        end
    end

    # ISSNs
    def import_add_issns(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding ISSN: #{v}")
                @bib.issns << StandardIdentifier.new(value: v)
            end
        end
    end

    # DOIs
    def import_add_dois(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding DOI: #{v}")
                @bib.dois << StandardIdentifier.new(value: v)
            end
        end
    end

    # Worldcat URLs
    def import_add_worldcat_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Worldcat URL: #{v}")
                @bib.worldcat_urls << Url.new(link: v)
            end
        end
    end

    # Dissertation University  URLs
    def import_dissertation_university_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Dissertation University URL: #{v}")
                @bib.dissertation_university_urls << Url.new(link: v)
            end
        end
    end

    # Publisher URLs
    def import_add_publisher_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Publisher URL: #{v}")
                @bib.publisher_urls << Url.new(link: v)
            end
        end
    end

    # Leuven URLs
    def import_add_leuven_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Leuven URL: #{v}")
                @bib.leuven_urls << Url.new(link: v)
            end
        end
    end

    # Event URLs
    def import_add_event_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Event URL: #{v}")
                @bib.event_urls << Url.new(link: v)
            end
        end
    end

    # Multimedia URLs
    def import_add_multimedia_urls(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Multimedia URL: #{v}")
                @bib.multimedia_urls << Url.new(link: v)
            end
        end
    end

    # Periods/Centuries
    def import_add_periods(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Period: #{v}")
                @bib.periods << Period.find_or_create_by(name: v, sort_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Subjects
    def import_add_subjects(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Subject: #{v}")
                @bib.subjects << Subject.find_or_create_by(name: v, sort_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Locations
    def import_add_locations(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Location: #{v}")
                @bib.locations << Location.find_or_create_by(name: v, sort_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Entities/Jesuits
    def import_add_jesuits(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Entity: #{v}")
                @bib.entities << Entity.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Notes -- Note
    def import_add_notes(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Note: #{v}")
                @bib.comments << Comment.new(body: v, comment_type: 'Note', commenter: 'importer', make_public: false)
            end
        end
    end

    # Notes -- Note to Editor
    def import_add_notes_to_editor(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Note: #{v}")
                @bib.comments << Comment.new(body: v, comment_type: 'Note to editor', commenter: 'importer', make_public: false)
            end
        end
    end

    # Translated Authors
    def import_add_translated_authors(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Translated author: #{v}")
                p = Person.find_or_create_by(name: v, sort_name: v, display_name: v, created_by: CREATED_BY_USER)
                @bib.translated_authors << TranslatedAuthor.new(bibliography_id: @bib.id, person_id: p.id)
            end
        end
    end

    # Languages
    def import_add_languages(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Language: #{v}")
                @bib.languages << Language.find_or_create_by(name: v, sort_name: v, created_by: CREATED_BY_USER)
            end
        end
    end

    # Abstract
    def import_add_abstract(bib, col)
        if col
            col.unicode_normalize!
            formatted_abstract = ""
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                formatted_abstract << "<p>#{v}</p>"
            end
            @bib.abstract = formatted_abstract
        end
    end

    # Tags
    def import_add_tags(bib, col)
        if col
            col.unicode_normalize!
            values = col.split(PIPE_DELIMITER_REGEX)
            values.each do |v|
                import_logger.info("  adding Tag: #{v}")
                @bib.tags << Tag.new(name: v)
            end
        end
    end
end
