$(document).bind((window.Turbolinks ? 'turbolinks:load' : 'ready'), function() {
    ClientSideValidations.disableValidators();
    return $(ClientSideValidations.selectors.forms).validate();
});