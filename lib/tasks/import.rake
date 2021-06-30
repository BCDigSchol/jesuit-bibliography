require 'csv'
require 'yaml'

namespace :import do
    desc "Run all import tasks"
    task :all => [:users, :pages]

    desc "Import test Users"
    task users: :environment do
        puts "Deleting existing users prior to import"
        User.destroy_all

        # get test_account_password value
        #password = Rails.application.credentials[Rails.env.to_sym][:test_account_password]
        #password = ENV.fetch("test_account_password", "password")
        password = ENV["TEST_ACCOUNT_PASSWORD"] || Rails.application.credentials.dig(:test_account_password)
        puts "using password: '#{password}'"

        puts "Starting Users import..."
        item_count = 0
        start = Time.now
        CSV.foreach('db/imports/users.csv', 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            item_count += 1

            # email,password,name,role
            # 0     1        2    3

            #@user = User.create!(row.to_h)

            @user = User.find_or_create_by(email: row[0]) do |user|
                user.password = password
                user.password_confirmation = password
                user.name = row[2]
                user.role = row[3]
            end

            # update sample user accounts so they are confirmed and ready to use
            @user.confirmed_at = DateTime.now
            @user.save
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} User records in #{diff} seconds\n\n"
    end

    desc "Import Static Pages"
    task pages: :environment do
        path = "db/imports/staticpages"
        file_type_regex = "*.yml"
        all_files = "#{path}/#{file_type_regex}"

        page_keys = ['name', 'route', 'description', 'slug', 'rank', 'body']

        begin
            # first, check that this directory exists
            yml_files = Dir.entries(path).select {|f| File.file? f}
        rescue Errno::ENOENT => ex
            puts "ERROR: #{ex}"
        else
            # next, grab all the files matching file_type_regex 
            yml_files = Dir.glob(all_files)
            puts "I found the following yml files: #{yml_files}\n\n"

            # next, parse each file
            yml_files.each do |file|
                page_array = YAML.load(File.read(file))

                puts "Reading in file \"#{file}\" and checking that all required fields are present"

                # check that we are finding all the elements we need for the Staticpage model
                if page_array.present?
                    ignore_this_file = false
                    page_keys.each do |key|
                        if page_array.include? key and page_array[key].present?
                            #puts "Great! I found \"#{key}\" in this file"
                        else
                            puts "ERROR: couldn't find \"#{key}\" in this file. Skipping this file\n\n"
                            ignore_this_file = true
                            break
                        end
                    end

                    # we are satisfied that we have all the components
                    unless ignore_this_file
                        puts "Success! All required fields are present"
                        
                        page = Staticpage.find_or_create_by(
                            name: page_array['name'], 
                            slug: page_array['slug'], 
                            description: page_array['description'],
                            rank: page_array['rank'],
                            body: page_array['body']
                        )

                        puts "Created/updated Staticpage \"#{page.name}\"\n\n"
                    end
                end
            end

            puts "Task complete."
        end
    end
end
