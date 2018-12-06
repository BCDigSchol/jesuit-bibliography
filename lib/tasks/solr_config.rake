require 'csv'

namespace :solr_config do

    desc "Update local SOLR config files"
    task update: :environment do
        # TODO make sure this can only be run in development
        
        local_solr_configs_home = Rails.root.join('solr/blacklight-core/conf/')
        solr_conf_home = ENV['SOLR_CONF_HOME_FOO'] || nil
        solr_config_files = ["managed-schema", "solrconfig.xml"]

        puts "Update SOLR config files on this computer."
        
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
        puts "\nChecking for local project SOLR config files:"
        local_solr_configs_home_exists = File.directory?(local_solr_configs_home)
        if local_solr_configs_home_exists
            puts "Project SOLR config files directory: \"#{local_solr_configs_home}\""
        else
            puts "WARNING: Could not find local solr config files."
            puts "Please check that \"#{local_solr_configs_home}\" is a valid directory and try again.\n\n"
            next
        end

        # check that the solr_config_files files exist and are not empty
        puts "\nChecking for local project SOLR config files:"
        solr_config_files.each do |file_name|
            file_path = local_solr_configs_home.join(file_name)
            file_size = File.size?(file_path)

            if !file_size.nil?
                puts "Found #{file_name} with size #{file_size}"
            else
                puts "WARNING: File #{file_name} either doesn't exist or is a zero-length file."
                puts "Please check this file and try again.\n\n"
                next
            end
        end

        # copy over files to SOLR_CONF_HOME
        puts "\nNow copying over SOLR config files"
        solr_config_files.each do |file_name|
            file_path = local_solr_configs_home.join(file_name)
            # TODO check for return value?
            FileUtils.cp_r(file_path, solr_conf_home, remove_destination: true)
        end

        puts "\nComplete! Please restart SOLR.\n"
    end
end