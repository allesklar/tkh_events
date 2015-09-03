module EventsHelper
  def parse_event(text)
    text = text.gsub /tkh_event_registration_english/, render('events/registration_with_email_english') if text.match(/tkh_event_registration_english/)
    text = text.gsub /tkh_event_registration_german/, render('events/registration_with_email_german') if text.match(/tkh_event_registration_german/)
    text
  end
end
