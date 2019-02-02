module FeaturedrecordsHelper
    def get_featured_records
        featured = Featuredrecord.order('featuredrecords.rank DESC').all
        featured
    end
end
