bar = ProgressBar.new

namespace :refresh_citation_records do
  desc 'Refreshes records'

  namespace :by_reference_type do
    desc 'Refreshes records by type'

    task book: :environment do
      batch_update("Book")
    end

    task book_chapter: :environment do
      batch_update("Book Chapter")
    end

    task book_review: :environment do
      batch_update("Book Review")
    end

    task journal_article: :environment do
      batch_update("Journal Article")
    end

    task dissertation: :environment do
      batch_update("Dissertation")
    end

    task conference_paper: :environment do
      batch_update("Conference Paper")
    end

    task multimedia: :environment do
      batch_update("Multimedia")
    end


    def batch_update(ref_type)
      start = Time.now

      # find all Bibliography records that are published, and are of type ref_type
      citations = Bibliography.where(reference_type: ref_type)
              .where(status: "published")
              .order(:id)

      total_number_of_citations = citations.count

      puts "Total number of Bibliography records of reference type #{ref_type} to update: #{total_number_of_citations}"

      bar = ProgressBar.new(total_number_of_citations)

      # update each citation
      citations.each do |citation|

        # display useful message
        bar.puts("updating citation record with ID##{citation.id}, Title: #{citation.display_title}")

        # this method triggers:
        #    citation.set_display_fields
        #    citation.generate_all_citations
        #    citation.modified_by = "admin"
        #    citation.save
        citation.refresh

        # reindex
        Sunspot.index! citation

        # update progress bar
        bar.increment!
      end

      finish = Time.now
      diff = finish - start
      puts "\n\n========================================================================================================================"
      puts "Updated #{total_number_of_citations} Bibliography records of reference type #{ref_type} in #{diff} seconds\n\n"
    end
  end
end