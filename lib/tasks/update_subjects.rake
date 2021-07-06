bar = ProgressBar.new

namespace :subjects do

  namespace :update do
    desc 'Updates subject labels to remove "Foreign" from "Foreign Missions"'
    task foreign_missions: :environment do

      start = Time.now

      # find all Subjects that have the term "Foreign Missions" in the name
      subjects = Subject.where("name like ?", "%Foreign Missions%").order(:id)

      total_number_of_subjects = subjects.count

      # get total number of referenced bib records
      total_number_of_ref_bibs = 0
      subjects.each do |sub|
        total_number_of_ref_bibs += sub.bib_refs.count
      end

      puts "Total number of Subject records: #{total_number_of_subjects}"
      puts "Total number of referenced bibliography records: #{total_number_of_ref_bibs}"
      bar = ProgressBar.new(total_number_of_subjects)

      # update each subject record
      subjects.each do |sub|
          sub.name.gsub! "Foreign Missions", "Missions"
          sub.sort_name.gsub! "Foreign Missions", "Missions"
          sub.normal_name.gsub! "Foreign Missions", "Missions"

          # update modified_by field
          sub.modified_by = "admin"

          sub.save
          
          # update progress bar
          bar.puts("reindexing %4d Bibliography records after updating Subject #%4d: #{sub.name} " % [sub.bib_refs.count, sub.id] )
          bar.increment!
      end

      finish = Time.now
      diff = finish - start
      puts "Updated #{total_number_of_subjects} Subject records, and reindexed #{total_number_of_ref_bibs} Bibliography records in #{diff} seconds\n\n"

    end
  end
end