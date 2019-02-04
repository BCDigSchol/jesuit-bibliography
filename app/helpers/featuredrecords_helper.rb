module FeaturedrecordsHelper
    def get_featured_records
        featured = Featuredrecord.where(published: :true).order('featuredrecords.rank DESC').all
        featured
    end
end
