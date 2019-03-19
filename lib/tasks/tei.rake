require 'csv'
require 'progress_bar'

namespace :tei do
    desc "Render TEI file of data"
    task :render, [:file] => :environment do |t, args|
        args.with_defaults(:file => "/home/blacklight/jesuit-bibliography-tei.xml")

        per_page = 50
        page = 0

        total_bibs = Bibliography.count

        puts "Rendering all records to #{args.file}"

        bar = ProgressBar.new(total_bibs)

        open(args.file, 'a') {|f|
            while page * per_page < total_bibs
                page += 1
                f.puts fetch(page, per_page)
                bar.increment! per_page
            end
        }
        puts "Finished"
    end

    def fetch(page, per_page = 100)
        solr_result = Bibliography.search do
            paginate :page => page, :per_page => per_page
            order_by(:updated_at, :asc)
        end

        ApiController.render :action => 'all.xml.builder', locals: {
            bibs: solr_result.results
        }
    end
end
