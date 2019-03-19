module ApiHelper
    def split_names(name)
        names = name.split(',')
        if names.length < 2
            names[1] = ''
        end
        names[1].strip!
        names
    end

    def format_creation_date(date)
        date.strftime('%Y%m%d')
    end
end