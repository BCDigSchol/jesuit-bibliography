class CreateDefaultPeriods < ActiveRecord::Migration[5.2]
    def change
        # Initialize periods:
        Period.create! do |u|
            u.name      = '1st century'
            u.sort_name = '001st century'
        end

        Period.create! do |u|
            u.name     = '2nd century'
            u.sort_name = '002nd century'
        end

        Period.create! do |u|
            u.name     = '3rd century'
            u.sort_name = '003rd century'
        end

        Period.create! do |u|
            u.name     = '4th century'
            u.sort_name = '004th century'
        end

        Period.create! do |u|
            u.name     = '5th century'
            u.sort_name = '005th century'
        end

        Period.create! do |u|
            u.name     = '6th century'
            u.sort_name = '006th century'
        end

        Period.create! do |u|
            u.name     = '7th century'
            u.sort_name = '007th century'
        end

        Period.create! do |u|
            u.name     = '8th century'
            u.sort_name = '008th century'
        end

        Period.create! do |u|
            u.name     = '9th century'
            u.sort_name = '009th century'
        end

        Period.create! do |u|
            u.name     = '10th century'
            u.sort_name = '010th century'
        end

        Period.create! do |u|
            u.name     = '11th century'
            u.sort_name = '011th century'
        end

        Period.create! do |u|
            u.name     = '12th century'
            u.sort_name = '012th century'
        end

        Period.create! do |u|
            u.name     = '13th century'
            u.sort_name = '013th century'
        end

        Period.create! do |u|
            u.name     = '14th century'
            u.sort_name = '014th century'
        end

        Period.create! do |u|
            u.name     = '15th century'
            u.sort_name = '015th century'
        end

        Period.create! do |u|
            u.name     = '16th century'
            u.sort_name = '016th century'
        end

        Period.create! do |u|
            u.name     = '17th century'
            u.sort_name = '017th century'
        end

        Period.create! do |u|
            u.name     = '18th century'
            u.sort_name = '018th century'
        end

        Period.create! do |u|
            u.name     = '19th century'
            u.sort_name = '019th century'
        end

        Period.create! do |u|
            u.name     = '20th century'
            u.sort_name = '020th century'
        end

        Period.create! do |u|
            u.name     = '21st century'
            u.sort_name = '021st century'
        end
    end
  end
  