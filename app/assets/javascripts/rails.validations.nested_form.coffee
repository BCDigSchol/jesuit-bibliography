ClientSideValidations.formBuilders['NestedForm::SimpleBuilder'] = ClientSideValidations.formBuilders['SimpleForm::FormBuilder'];

# https://github.com/DavyJonesLocker/client_side_validations-simple_form/issues/65#issuecomment-407668046
ClientSideValidations.formBuilders['SimpleForm::FormBuilder'].wrappers.default =
  add: (element, settings, message) ->
    wrapperElement = element.closest("#{settings.wrapper_tag}")
    errorElement   = wrapperElement.find("#{settings.error_tag}.invalid-feedback")

    unless errorElement.length
      errorElement = $("<#{settings.error_tag}/>", { class: 'invalid-feedback', text: message })
      wrapperElement.append errorElement

    wrapperElement.addClass settings.wrapper_error_class
    element.addClass 'is-invalid'

    errorElement.text message

    # regex matches input field name values that match the pattern "bibliography[foo]".
    # other repeatable fields and authority dropdowns have a more complex naming structure 
    # than what is being searched here.
    regex = /bibliography\[(.*)\]/
    field_name = regex.exec("#{element.context.name}")

    # add the element's error message to the error-panel display and make it visible, 
    # which may be hidden from view 
    $(".error-panel-clientside").find(".panel-body").append("<p id='#{element.context.id}'>#{field_name[1]} #{message}</p>")
    $(".error-panel-clientside").show()

  remove: (element, settings) ->
    wrapperElement = element.closest("#{settings.wrapper_tag}")
    errorElement   = wrapperElement.find("#{settings.error_tag}.invalid-feedback")

    wrapperElement.removeClass settings.wrapper_error_class
    element.removeClass 'is-invalid'

    errorElement.remove()

    # remove the error message if it matches the calling element
    $(".error-panel-clientside").find("p#" + "#{element.context.id}").remove()

    # hide the error-panel if there are no more error messages
    unless $(".error-panel-clientside").find("p").length > 0
      $(".error-panel-clientside").hide()
