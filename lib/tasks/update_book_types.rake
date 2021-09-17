bar = ProgressBar.new
reindexer = ProgressBar.new

namespace :books do

  namespace :update do
    desc 'Updates display_author field for records that are missing an author value'
    task display_author: :environment do

      start = Time.now

      # find all Bibliogrpahy records that are published, are of type 'Book' and lack an author relation
      books = Bibliography.left_outer_joins(:authors)
              .where(reference_type: "Book")
              .where(status: "published")
              .where(authors: {bibliography_id: nil})
              .order(:id)

      # Raw SQL
      #
      # SELECT "bibliographies"."id"
      # FROM "bibliographies" LEFT OUTER JOIN "authors"
      # ON "authors"."bibliography_id" = "bibliographies"."id"
      # WHERE "bibliographies"."reference_type" = "Book"
      # AND "bibliographies"."status" = "published"
      # AND "authors"."bibliography_id" IS NULL
      # ORDER BY "bibliographies"."id" ASC

      total_number_of_books = books.count

      puts "Total number of Bibliography records: #{total_number_of_books}"
      bar = ProgressBar.new(total_number_of_books)

      # update each subject record
      books.each do |book|

        # display useful message
        bar.puts("updating Bib record with ID##{book.id}, Title: #{book.title}")

        # this method triggers:
        #    book.set_display_fields
        #    book.generate_all_citations
        #    book.modified_by = "admin"
        #    book.save
        book.refresh

        # reindex
        Sunspot.index! book

        # update progress bar
        bar.increment!
      end

      finish = Time.now
      diff = finish - start
      puts "\n\n========================================================================================================================"
      puts "Updated #{total_number_of_books} Bibliography records in #{diff} seconds\n\n"

    end
  end
end