SitemapGenerator::Sitemap.default_host = "https://jesuitonlinebibliography.bc.edu"

SitemapGenerator::Sitemap.create(
    :sitemaps_path => 'sitemaps/'
) do

    # Config variable in environment ensures we only generate
    # maps in production
    break unless Rails.configuration.generate_sitemap

    # Add links here.

    ['jesuits', 'locations', 'subjects', 'centuries'].each do |page|
        add "/terms/#{page}"
    end

    Bibliography.find_each do |bib|
        add "/catalog/#{bib.id}", :lastmod => bib.updated_at
    end

    Staticpage.find_each do |page|
        add "/about/#{page.slug}", :lastmod => page.updated_at
    end
end
