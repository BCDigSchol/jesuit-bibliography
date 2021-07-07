bar = ProgressBar.new
reindexer = ProgressBar.new

namespace :subjects do

  namespace :update do
    desc 'Updates subject labels to remove "Foreign" from "Foreign Missions"'
    task foreign_missions: :environment do

      term_original = "Foreign Missions"
      term_updated  = "Missions"

      start = Time.now

      # find all Subjects that have the term "Foreign Missions" in the name
      subjects = Subject.where("name like ?", "%#{term_original}%").order(:id)

      total_number_of_subjects = subjects.count

      # collect total number of referenced bib records
      total_number_of_ref_bibs = 0

      puts "Total number of Subject records: #{total_number_of_subjects}"
      bar = ProgressBar.new(total_number_of_subjects)

      # update each subject record
      subjects.each do |sub|
        total_number_of_ref_bibs += sub.bib_refs.count

        sub.name.gsub! "#{term_original}", "#{term_updated}"
        sub.sort_name.gsub! "#{term_original}", "#{term_updated}"
        sub.normal_name.gsub! "#{term_original}", "#{term_updated}"

        # update modified_by field
        sub.modified_by = "admin"

        # display useful message since many of these individual Subject updates can take a while...
        bar.puts("reindexing %4d Bibliography records after updating Subject #%4d: #{sub.name} " % [sub.bib_refs.count, sub.id] )

        # save Subject record, which triggers a refresh and reindex of all associated Bibliography records
        sub.save

        # update progress bar
        bar.increment!
      end

      finish = Time.now
      diff = finish - start
      puts "\n\n========================================================================================================================"
      puts "Updated #{total_number_of_subjects} Subject records, and reindexed #{total_number_of_ref_bibs} Bibliography records in #{diff} seconds\n\n"

    end
  end
end