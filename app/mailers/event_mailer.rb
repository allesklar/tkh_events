class EventMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: "#{Setting.first.try(:site_name)} <#{Setting.first.contact_email}>"

  def confirmation(user, event)
    @user = user
    @event = event
    subject = "Registration confirmation"
    mail to: "#{@user.name} <#{@user.email}>", subject: subject do |format|
      format.html { render layout: 'event_public_emails.html.erb' }
      format.text
    end
  end
end
