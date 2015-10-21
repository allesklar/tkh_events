jQuery ->
  # Typeahead form fields for autocomplete associations
  $('#registration_registrant_email').typeahead(
    name: 'registration_registrant_email',
    local: $('#registration_registrant_email').data('source') )
