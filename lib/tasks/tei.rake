require 'csv'
require 'progress_bar'

namespace :tei do
    desc "Render TEI file of data"
    task :render, [:file] => :environment do |t, args|
        args.with_defaults(:file => "/home/blacklight/export/jesuit-bibliography-tei.xml")

        # Delete old XML file if it exists.
        File.delete(args.file) if File.exist?(args.file)
        puts "Rendering all records to #{args.file}"

        total_bibs = Bibliography.count
        puts "#{total_bibs} bib records found"

        # Open the file for appending and render the bibs.
        open(args.file, 'a') {|f|
            render_bibs(f, total_bibs)
        }

        puts "Finished"
    end

    # Fetch bibs from Solr in batches an add to XML file
    def render_bibs(xml_file, total_bibs)
        bar = ProgressBar.new(total_bibs)

        per_page = 50
        page = 0

        while page * per_page < total_bibs
            page += 1
            xml_file.puts fetch(page, per_page)
            bar.increment! per_page
        end
    end

    # Fetch one batch of bibs and render as XML
    def fetch(page, per_page)
        solr_result = Bibliography.search do
            paginate :page => page, :per_page => per_page
            order_by(:updated_at, :asc)
        end

        # Render using Builder template in /views/api
        ApiController.render :action => 'all.xml.builder', locals: {
            bibs: solr_result.results
        }
    end
end
