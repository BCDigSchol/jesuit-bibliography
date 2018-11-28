require 'csv'
require 'progress_bar'

bar = ProgressBar.new

def import_logger
    @import_logger ||= Logger.new("#{Rails.root}/log/import_bibs.log")
end

namespace :importdata do

    desc "Destroy all Bibliography records"
    task clear_all: :environment do
        bar = ProgressBar.new(9)
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
        Citation.destroy_all
        bar.increment!
        Language.destroy_all
        bar.increment!
        puts "Task completed."
    end

    desc "Run all importdata tasks"
    task :all => [:clear_all, :books, :book_chapters]

    desc "Import test books"
    task books: :environment do

        puts "Starting Books import"
        import_logger.info("Starting Books import")

        # invoke destroy_all_bibs task to remove existing Bibliography records
        # Rake::Task["importdata:clear_all"].invoke

        item_count = 0
        start = Time.now
        total_lines = CSV.read('db/imports/books.csv', headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach('db/imports/books.csv', 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            # break if item_count >= 300

            # Reference Type,Author,Year,Title,Place Published,Publisher,Volume,Number of Volumes,Number of Pages,Editor,
            # 0              1      2    3     4               5         6      7                 8               9
            #
            # Edition,Translator,ISBN,DOI,Reprint Edition,WorldCat URL,Publisher URL,Leuven URL,When,What,
            # 10      11         12   13  14              15           16            17         18   19
            #
            # Where,Who,Abstract,Notes,Notes to Editors,Translated Author,Translated Title,Language
            # 20    21  22       23    24               25                26               27

            @bib = Bibliography.new

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            @bib.year_published = row[2]
            @bib.title = row[3]
            @bib.place_published = row[4]
            @bib.publisher = row[5]
            @bib.volume = row[6]
            @bib.number_of_volumes = row[7]
            @bib.number_of_pages = row[8]
            #@bib.editor = row[9]
            @bib.edition = row[10]
            #@bib.translator = row[11]
            #@bib.isbn = row[12]
            #@bib.doi = row[13]
            @bib.reprint_edition = row[14]
            @bib.worldcat_url = row[15]
            @bib.publisher_url = row[16]
            @bib.leuven_url = row[17]
            #@bib.when_subject = row[18]
            #@bib.what_subject = row[19]
            #@bib.where_subject = row[20]
            #@bib.who_subject = row[21]
            @bib.abstract = row[22]
            #@bib.notes = row[23]
            #@bib.notes_to_editor = row[24]
            #@bib.translated_author = row[25]
            @bib.translated_title = row[26]
            #@bib.languages = row[27]

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: Book")
            import_logger.info("  title: #{@bib.title}")
            import_logger.info("  year: #{@bib.year_published}")
            
            # Authors
            if row[1]
                values = row[1].split("|")
                values.each do |v|
                    import_logger.info("  adding Author: #{v}")
                    @bib.authors << Citation.new(display_name: v)
                end
            end

            # Editors
            if row[9]
                values = row[9].split("|")
                values.each do |v|
                    import_logger.info("  adding Editor: #{v}")
                    @bib.editors << Citation.new(display_name: v)
                end
            end

            # Translators
            if row[11]
                values = row[11].split("|")
                values.each do |v|
                    import_logger.info("  adding Translator: #{v}")
                    @bib.translators << Citation.new(display_name: v)
                end
            end

            # ISBNs
            if row[12]
                values = row[12].split("|")
                values.each do |v|
                    import_logger.info("  adding ISBN: #{v}")
                    @bib.isbns << StandardIdentifier.new(value: v)
                end
            end

            # DOIs
            if row[13]
                values = row[13].split("|")
                values.each do |v|
                    import_logger.info("  adding DOI: #{v}")
                    @bib.dois << StandardIdentifier.new(value: v)
                end
            end

            # Periods
            if row[18]
                values = row[18].split("|")
                values.each do |v|
                    import_logger.info("  adding Period: #{v}")
                    @bib.periods << Period.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Subjects
            if row[19]
                values = row[19].split("|")
                values.each do |v|
                    import_logger.info("  adding Subject: #{v}")
                    @bib.subjects << Subject.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Locations
            if row[20]
                values = row[20].split("|")
                values.each do |v|
                    import_logger.info("  adding Location: #{v}")
                    @bib.locations << Location.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Entities
            if row[21]
                values = row[21].split("|")
                values.each do |v|
                    import_logger.info("  adding Entity: #{v}")
                    @bib.entities << Entity.find_or_create_by(name: v, sort_name: v, display_name: v)
                end
            end

            # Notes -- Note
            if row[23]
                import_logger.info("  adding Note: #{row[23]}")
                @bib.comments << Comment.new(body: row[23], comment_type: 'Note', commenter: 'importer', make_public: false)
            end

            # Notes -- Note to editor
            if row[24]
                import_logger.info("  adding Note: #{row[24]}")
                @bib.comments << Comment.new(body: row[24], comment_type: 'Note to editor', commenter: 'importer', make_public: false)
            end

            # Translated Authors
            if row[25]
                values = row[25].split("|")
                values.each do |v|
                    import_logger.info("  adding Translated author: #{v}")
                    @bib.translated_authors << Citation.new(display_name: v)
                end
            end

            # Languages
            if row[27]
                values = row[27].split("|")
                values.each do |v|
                    import_logger.info("  adding Language: #{v}")
                    @bib.languages << Language.new(name: v)
                end
            end

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Books records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} Books records in #{diff} seconds")
    end

    desc "Import test book chapters"
    task book_chapters: :environment do

        puts "Starting Book chapters import"
        import_logger.info("Starting Book chapters import")

        # invoke destroy_all_bibs task to remove existing Bibliography records
        # Rake::Task["importdata:clear_all"].invoke

        item_count = 0
        start = Time.now
        total_lines = CSV.read('db/imports/book_chapters.csv', headers: true, liberal_parsing: true).length
        puts "Total rows in import file: #{total_lines}"
        bar = ProgressBar.new(total_lines)

        CSV.foreach('db/imports/book_chapters.csv', 
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

            @bib = Bibliography.new

            @bib.reference_type = row[0]
            #@bib.author = row[1]
            @bib.year_published = row[2]
            @bib.title = row[3]
            #@bib.book_editor = row[4]
            @bib.book_title = row[5]
            @bib.place_published = row[6]
            @bib.publisher = row[7]
            @bib.volume = row[8]
            @bib.number_of_volumes = row[9]
            @bib.page_range = row[10]
            @bib.chapter_number = row[11]
            @bib.edition = row[12]
            #@bib.translator = row[13]
            #@bib.isbn = row[14]
            #@bib.doi = row[15]
            @bib.reprint_edition = row[16]
            @bib.worldcat_url = row[17]
            @bib.publisher_url = row[18]
            @bib.leuven_url = row[19]
            #@bib.when_subject = row[20]
            #@bib.what_subject = row[21]
            #@bib.where_subject = row[22]
            #@bib.who_subject = row[23]
            @bib.abstract = row[24]
            #@bib.notes = row[25]
            #@bib.notes_to_editor = row[26]
            #@bib.translated_author = row[27]
            @bib.translated_title = row[28]
            #@bib.languages = row[29]

            @bib.save!

            import_logger.info("Saved bib with ID# #{@bib.id}")
            import_logger.info("  type: Book chapter")
            import_logger.info("  title: #{@bib.title}")
            import_logger.info("  year: #{@bib.year_published}")
            
            # Authors
            if row[1]
                values = row[1].split("|")
                values.each do |v|
                    import_logger.info("  adding Author: #{v}")
                    @bib.authors << Citation.new(display_name: v)
                end
            end

            # Book Editors
            if row[4]
                values = row[4].split("|")
                values.each do |v|
                    import_logger.info("  adding Book Editor: #{v}")
                    @bib.book_editors << Citation.new(display_name: v)
                end
            end

            # Translators
            if row[13]
                values = row[13].split("|")
                values.each do |v|
                    import_logger.info("  adding Translator: #{v}")
                    @bib.translators << Citation.new(display_name: v)
                end
            end

            # ISBNs
            if row[14]
                values = row[14].split("|")
                values.each do |v|
                    import_logger.info("  adding ISBN: #{v}")
                    @bib.isbns << StandardIdentifier.new(value: v)
                end
            end

            # DOIs
            if row[15]
                values = row[15].split("|")
                values.each do |v|
                    import_logger.info("  adding DOI: #{v}")
                    @bib.dois << StandardIdentifier.new(value: v)
                end
            end

            # Periods
            if row[20]
                values = row[20].split("|")
                values.each do |v|
                    import_logger.info("  adding Period: #{v}")
                    @bib.periods << Period.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Subjects
            if row[21]
                values = row[21].split("|")
                values.each do |v|
                    import_logger.info("  adding Subject: #{v}")
                    @bib.subjects << Subject.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Locations
            if row[22]
                values = row[22].split("|")
                values.each do |v|
                    import_logger.info("  adding Location: #{v}")
                    @bib.locations << Location.find_or_create_by(name: v, sort_name: v)
                end
            end

            # Entities
            if row[23]
                values = row[23].split("|")
                values.each do |v|
                    import_logger.info("  adding Entity: #{v}")
                    @bib.entities << Entity.find_or_create_by(name: v, sort_name: v, display_name: v)
                end
            end

            # Notes -- Note
            if row[25]
                import_logger.info("  adding Note: #{row[25]}")
                @bib.comments << Comment.new(body: row[25], comment_type: 'Note', commenter: 'importer', make_public: false)
            end

            # Notes -- Note to editor
            if row[26]
                import_logger.info("  adding Note: #{row[26]}")
                @bib.comments << Comment.new(body: row[26], comment_type: 'Note to editor', commenter: 'importer', make_public: false)
            end

            # Translated Authors
            if row[27]
                values = row[27].split("|")
                values.each do |v|
                    import_logger.info("  adding Translated author: #{v}")
                    @bib.translated_authors << Citation.new(display_name: v)
                end
            end

            # Languages
            if row[29]
                values = row[29].split("|")
                values.each do |v|
                    import_logger.info("  adding Language: #{v}")
                    @bib.languages << Language.new(name: v)
                end
            end

            bar.increment!
        end

        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Book Chapter records in #{diff} seconds\n\n"
        import_logger.info("Created #{item_count} Book Chapter records in #{diff} seconds")
    end
end
