namespace :solr_config do

    desc "Update local Solr config files"
    task update: :environment do
        puts "Reading ENV['SOLR_CONF_HOME'] = #{ENV['SOLR_CONF_HOME']}"

        local_solr_configs_home = Rails.root.join('solr/blacklight-core/conf/')
        solr_conf_home = ENV['SOLR_CONF_HOME']
        solr_config_files = ["managed-schema", "solrconfig.xml"]

        puts "Update Solr config files on this computer."
        
        # check that SOLR_CONF_HOME is not nil
        puts "\nChecking for SOLR_CONF_HOME environmental variable in this shell:"
        if !solr_conf_home.nil?
            puts "Found SOLR_CONF_HOME env var in this shell: \"#{solr_conf_home}\""
        else
            puts "WARNING: Could not find SOLR_CONF_HOME environment variable in this shell."
            puts "Please add SOLR_CONF_HOME to your shell profile and try again.\n\n"
            next
        end

        # check if SOLR_CONF_HOME directory exists
        solr_dir_exists = File.directory?(solr_conf_home)
        if solr_dir_exists
            puts "SOLR_CONF_HOME Directory exists on this computer."
        else
            puts "WARNING: This directory doesn't exist."
            puts "Please check that \"#{solr_conf_home}\" is a valid directory and try again.\n\n"
            next
        end

        # check that our local /path/to/jesuit-bibliography/solr/blacklight-core/conf directory exist
        puts "\nChecking for local project Solr config files:"
        local_solr_configs_home_exists = File.directory?(local_solr_configs_home)
        if local_solr_configs_home_exists
            puts "Project Solr config files directory: \"#{local_solr_configs_home}\""
        else
            puts "WARNING: Could not find local Solr config files."
            puts "Please check that \"#{local_solr_configs_home}\" is a valid directory and try again.\n\n"
            next
        end

        # check that the solr_config_files files exist and are not empty
        puts "\nChecking for local project Solr config files:"
        solr_config_files.each do |file_name|
            file_path = local_solr_configs_home.join(file_name)
            file_size = File.size?(file_path)

            if !file_size.nil?
                puts "Found file '#{file_name}' with size #{file_size} bytes"
            else
                puts "WARNING: File '#{file_name}' either doesn't exist or is a zero-length file."
                puts "Please check this file and try again.\n\n"
                next
            end
        end

        # copy over files to SOLR_CONF_HOME
        puts "\nNow copying over Solr config files."
        solr_config_files.each do |file_name|
            file_path = local_solr_configs_home.join(file_name)
            # TODO check for return value?
            FileUtils.cp_r(file_path, solr_conf_home, remove_destination: true)
        end

        puts "\nTask complete! \n\nPlease restart Solr to have the configuration changes applied.\n"
    end

    desc "Drop Solr index"
    task dropall: :environment do
        puts "This will remove all records in the SOLR index..."

        Sunspot.remove_all!(Bibliography)

        puts "Removal complete."
    end

    namespace :reindex_by_type do
        document_types_list = ['book', 'book_chapter', 'book_review', 'journal_article', 'dissertation', 'conference_paper', 'multimedia']

        document_types_list.each do | ref_type |
            desc "reindex by document reference type #{ref_type}"
            task ref_type => :environment do
                puts "Document reference type: #{ref_type}"

                ref_type_mod = ref_type.titleize
                puts "Converting to standard format: #{ref_type_mod}"
                @matches = Bibliography.where(reference_type: ref_type_mod)

                puts "There are #{@matches.count} records that match this document reference type."

                puts "Begin reindexing of these #{@matches.count} records..."

                # convert ActiveRecord::Relation object type to array 
                @matches_array = @matches.to_a.map {|u| u}

                # reindex every record and commit
                Sunspot.index! @matches_array
                
                puts "Reindexing completed."
            end
        end
    end

    namespace :update_by_type do
        document_types_list = ['book', 'book_chapter', 'book_review', 'journal_article', 'dissertation', 'conference_paper', 'multimedia']

        document_types_list.each do | ref_type |
            desc "update and reindex by document reference type #{ref_type}"
            task ref_type => :environment do
                puts "Document reference type: #{ref_type}"

                ref_type_mod = ref_type.titleize
                puts "Converting to standard format: #{ref_type_mod}"
                @matches = Bibliography.where(reference_type: ref_type_mod)

                puts "There are #{@matches.count} records that match this document reference type."

                puts "Begin updating of these #{@matches.count} records..."

                # index in batches for CPU/time efficiency
                solr_batch = SolrBatch.new index_batch_size: 100, commit_batch_size: 1000, commit_sleep_seconds: 2

                # save/update each record; very slow
                @matches.each do |bib| 
                    bib.refresh
                    solr_batch.add bib
                end

                # index and commit any remaining records
                solr_batch.close

                puts "Saving/Updating/Reindexing completed."
            end
        end
    end
       
end