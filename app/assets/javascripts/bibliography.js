function select2_config(field_selector, record_type) {
    return {
        ajax: {
            data: function (params) {
                return {
                    term: params.term,
                    type: record_type
                };
            },
            dataType: "json",
            delay: 250,
            url: $(field_selector).data("url"),
            processResults: function (data) {
                return {
                    results: data
                }
            }
        },
        minimumInputLength: 2
    }
};
