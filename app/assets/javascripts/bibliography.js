function select2_config(field_selector, record_type, allowclear, placeholder_text) {
    // js support of default parameters has limited support, and causes an error with Uglifier
    // instead, catch then the params are undefined and apply a default value here
    if(typeof allowclear === "undefined") {
        allowclear = false;
    }
    if(typeof placeholder_text === "undefined") {
        placeholder_text = null;
    }

    return {
        ajax: {
            data: function (params) {
                return {
                    term: params.term,
                    type: record_type,
                    format: 'json'
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
        minimumInputLength: 1,
        // only activate this on certain occasions
        allowClear: allowclear,
        placeholder: placeholder_text,
        language: {
            inputTooShort: function () {
              return "Please enter 1 or more characters. To display all possible values, type the wildcard character `*`";
            }
        }
    }
};
