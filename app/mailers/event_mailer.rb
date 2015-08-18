class EventMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  $site_sender = "#{Setting.first.try(:site_name)} <#{Setting.first.contact_email}>"

  def confirmation(user, event)
    @user = user
    @event = event

    senders = []
    senders << $site_sender
    event.organizers.each do |organizer|
      senders << "#{organizer.name} <#{organizer.email}>"
    end

    subject = "Registration confirmation for the #{@event.short_name}"
    mail to: "#{@user.name} <#{@user.email}>",
          from: senders.join(","),
          subject: subject do |format|
      format.html { render layout: 'event_public_emails.html.erb' }
      format.text
    end
  end
end
