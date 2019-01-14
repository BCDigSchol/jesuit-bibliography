require 'csv'

namespace :import do
    desc "Run all import tasks"
    task :all => [:users, :periods, :locations, :subjects, :entities]

    desc "Import test Users"
    task users: :environment do
        puts "Deleting existing users prior to import"
        User.destroy_all

        puts "Starting Users import..."
        item_count = 0
        start = Time.now
        CSV.foreach('db/imports/users.csv', 
            headers: true,
            encoding: Encoding::UTF_8,
            liberal_parsing: true
        ) do |row|
            #puts row
            item_count += 1
            User.create!(row.to_h)
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} User records in #{diff} seconds\n\n"
    end

    desc "Import test Periods"
    task periods: :environment do
=begin
        puts "Starting Periods import..."
        item_count = 0
        start = Time.now
        CSV.foreach('db/imports/periods.csv', 
            headers: true,
            encoding: Encoding::UTF_8,
        ) do |row|
            #puts row
            item_count += 1
            Period.create!(row.to_h)
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Period records in #{diff} seconds\n\n"
=end
    end

    desc "Import test Locations"
    task locations: :environment do
=begin
        puts "Starting Locations import..."
        item_count = 0
        start = Time.now
        CSV.foreach(
            'db/imports/locations.csv',
            headers: true, 
            col_sep: ';;',
            encoding: Encoding::UTF_8, 
            liberal_parsing: true
        ) do |row|
            #puts row
            item_count += 1
            Location.create!(row.to_h)
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Location records in #{diff} seconds\n\n"
=end
    end

    desc "Import test Subjects"
    task subjects: :environment do
=begin
        puts "Starting Subjects import..."
        item_count = 0
        start = Time.now
        CSV.foreach(
            'db/imports/subjects.csv',
            headers: true, 
            col_sep: ';;',
            encoding: Encoding::UTF_8, 
            liberal_parsing: true
        ) do |row|
            #puts row
            item_count += 1
            Subject.create!(row.to_h)
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Subject records in #{diff} seconds\n\n"
=end
    end

    desc "Import test Entities"
    task entities: :environment do
=begin
        puts "Starting Entities import..."
        item_count = 0
        start = Time.now
        CSV.foreach(
            'db/imports/entities.csv',
            headers: true, 
            col_sep: ';;',
            encoding: Encoding::UTF_8, 
            liberal_parsing: true
        ) do |row|
            #puts row
            item_count += 1
            Entity.create!(row.to_h)
        end
        finish = Time.now
        diff = finish - start
        puts "Created #{item_count} Entity records in #{diff} seconds\n\n"
=end
    end
end
