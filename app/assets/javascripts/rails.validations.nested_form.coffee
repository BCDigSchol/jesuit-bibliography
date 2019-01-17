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

  remove: (element, settings) ->
    wrapperElement = element.closest("#{settings.wrapper_tag}")
    errorElement   = wrapperElement.find("#{settings.error_tag}.invalid-feedback")

    wrapperElement.removeClass settings.wrapper_error_class
    element.removeClass 'is-invalid'

    errorElement.remove()
