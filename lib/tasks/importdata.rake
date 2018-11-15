require 'csv'

namespace :importdata do
    #desc "Run all importdata tasks"
    #task :all => [:users, :periods, :locations, :subjects, :entities]

    desc "Import test books"
    task books: :environment do
        puts "Starting Books import..."

        puts "First, remove all previous records\n\n"
        Bibliography.destroy_all
        StandardIdentifier.destroy_all
        Comment.destroy_all
        Location.destroy_all
        Period.destroy_all
        Subject.destroy_all
        Entity.destroy_all
        Citation.destroy_all

        item_count = 0
        start = Time.now
        CSV.foreach('db/imports/books.csv', 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1
            break if item_count >= 300

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
            @bib.secondary_url = row[16]
            @bib.leuven_url = row[17]
            #@bib.when_subject = row[18]
            #@bib.what_subject = row[19]
            #@bib.where_subject = row[20]
            #@bib.who_subject = row[21]
            @bib.abstract = row[22]
            #@bib.notes = row[23]
            #@bib.notes_to_editor = row[24]
            #@bib.translated_author = row[25]
            @bib.title_translated = row[26]
            @bib.language = row[27]

            @bib.save!

            puts "Saved bib with ID# #{@bib.id}"

            if row[1]
                values = row[1].split("|")
                values.each do |v|
                    puts "\tadding Author: #{v}"
                    @bib.authors << Citation.new(display_name: v)
                end
                
            end

            if row[9]
                values = row[9].split("|")
                values.each do |v|
                    puts "\tadding Editor: #{v}"
                    @bib.editors << Citation.new(display_name: v)
                end
            end

            if row[11]
                values = row[11].split("|")
                values.each do |v|
                    puts "\tadding Translator: #{v}"
                    @bib.translators << Citation.new(display_name: v)
                end
            end

            if row[12]
                values = row[12].split("|")
                values.each do |v|
                    puts "\tadding ISBN: #{v}"
                    @bib.isbns << StandardIdentifier.new(value: v)
                end
            end

            if row[13]
                values = row[13].split("|")
                values.each do |v|
                    puts "\tadding DOI: #{v}"
                    @bib.dois << StandardIdentifier.new(value: v)
                end
            end

            if row[18]
                values = row[18].split("|")
                values.each do |v|
                    puts "\tadding Period term: #{v}"
                    @bib.periods << Period.find_or_create_by(name: v, sort_name: v)
                end
            end

            if row[19]
                values = row[19].split("|")
                values.each do |v|
                    puts "\tadding Subject term: #{v}"
                    @bib.subjects << Subject.find_or_create_by(name: v, sort_name: v)
                end
            end

            if row[20]
                values = row[20].split("|")
                values.each do |v|
                    puts "\tadding Location term: #{v}"
                    @bib.locations << Location.find_or_create_by(name: v, sort_name: v)
                end
            end

            if row[21]
                values = row[21].split("|")
                values.each do |v|
                    puts "\tadding Entity term: #{v}"
                    @bib.entities << Entity.find_or_create_by(name: v, sort_name: v, display_name: v)
                end
            end

            if row[23]
                puts "\tadding Note: #{row[23]}"
                @bib.comments << Comment.new(body: row[23], comment_type: 'Note', commenter: 'importer', make_public: false)
            end

            if row[24]
                puts "\tadding Note to editor: #{row[24]}"
                @bib.comments << Comment.new(body: row[24], comment_type: 'Note to editor', commenter: 'importer', make_public: false)
            end

            if row[25]
                values = row[25].split("|")
                values.each do |v|
                    puts "\tadding Translated author: #{v}"
                    @bib.translated_authors << Citation.new(display_name: v)
                end
            end

            puts

        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Books records in #{diff} seconds\n\n"
    end
end
