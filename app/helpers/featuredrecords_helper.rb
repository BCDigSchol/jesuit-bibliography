module FeaturedrecordsHelper
    def get_featured_records
        Featuredrecord.where(published: :true).order('featuredrecords.rank DESC').all
    end
end
