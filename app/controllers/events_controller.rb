class EventsController < ApplicationController

  before_filter :authenticate,            :except => [ 'show', 'register' ]
  before_filter :authenticate_with_admin, :except => [ 'show', 'register' ]

  before_action :set_event, only: [ :show, :edit, :update, :destroy, :publish, :register, :unregister, :admin_view, :add_organizer, :remove_organizer, :register_someone ]

  def index
    @events = Event.by_recent.paginate page: params[:page], per_page: 20
    switch_to_admin_layout
  end

  def admin_view
    @registration = Registration.new
    switch_to_admin_layout
  end

  def show
  end

  def new
    @event = Event.new
    switch_to_admin_layout
  end

  def edit
    switch_to_admin_layout
  end

  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def duplicate
    Event.duplicate(params[:id])
    redirect_to events_path, notice: 'Your event has been duplicated.'
  end

  def publish
    @event.published = true
    @event.save
    redirect_to @event, notice: 'This event was published'
  end

  def add_organizer
    event_organizer = EventOrganizer.create event_id: @event.id, organizer_id: params[:event][:organizer_id]
    if event_organizer
      redirect_to admin_view_event_path(@event), notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> A new organizer has been added to this event.".html_safe
    else
      redirect_to admin_view_event_path(@event), warning: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> There was a problem adding the organizer to the event. Please try again.".html_safe
    end
  end

  def remove_organizer
    event_organizer = EventOrganizer.find_by event_id: @event.id, organizer_id: params[:organizer_id]
    event_organizer.destroy
    redirect_to admin_view_event_path(@event), notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> The organizer has been removed.".html_safe
  end

  def register
    unless current_user # straight email registration for most people who are not logged in
      if params[:event][:email].present?
        user = Member.find_or_create_by email: params[:event][:email]
        registration = Registration.create event_id: @event.id, registrant_id: user.id
        if user && registration
          Activity.create doer_id: user.id, message: "registered for the event entitled: #{view_context.link_to @event.short_name, @event}"
          send_confirmation_email(user)
          redirect_to @event, notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> You have been registered for this event. Please check your <strong>inbox</strong> or <strong>spam folder</strong> for your confirmation.".html_safe
        else
          redirect_to @event, alert: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> There was a problem recording your registration. Please try again.".html_safe
        end
      else
        redirect_to @event, alert: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> You need to provide a valid email address in order to register for this program.".html_safe
      end
    else # the user is already logged in
      registration = Registration.create event_id: @event.id, registrant_id: current_user.id
      if registration
        Activity.create doer_id: current_user.id, message: "registered for the event entitled: #{view_context.link_to @event.short_name, @event}"
        send_confirmation_email(current_user)
        redirect_to @event, notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> You have been registered for this event. Please check your <strong>inbox</strong> or <strong>spam folder</strong> for your confirmation.".html_safe
      else
        redirect_to @event, warning: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> There was a problem recording your registration. Please try again.".html_safe
      end
    end
  end

  def register_someone
    registration = Registration.create event_id: @event.id, registrant_id: Registrant.find_by( email: params[:registration][:registrant_email]).id
      if registration
        Activity.create doer_id: current_user.id, message: "registered #{view_context.link_to registration.registrant.name_or_email, member_path(registration.registrant)} for the event entitled: #{view_context.link_to @event.short_name, @event}."
        # send_confirmation_email(current_user) # OPTIMIZE - may be implement this as an option later
        redirect_to admin_view_event_path(@event), notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> You have registered #{view_context.link_to registration.registrant.name_or_email, member_path(registration.registrant)} for this event. ".html_safe
      else
        redirect_to admin_view_event_path(@event), warning: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> There was a problem registering this person for this event".html_safe
      end
  end

  def unregister
    registration = Registration.find params[:registration_id]
    registration.destroy
    redirect_to admin_view_event_path(@event), notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> The registration has been deleted.".html_safe
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      # email attribute is an attr-reader used in the event registration partials
      params.require(:event).permit( :name, :nickname, :tiny_name, :description, :body, :starts_at, :price, :maximum_number_of_registrants, :confirmation_emails_text, :confirmation_emails_html, :published, :image, :email )
    end

    def send_confirmation_email(participant)
      begin
        EventMailer.confirmation(participant, @event).deliver_now
      rescue Exception => e
        AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send an event confirmation email.").deliver_now
      end
    end
end
