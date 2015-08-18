class EventsController < ApplicationController

  before_filter :authenticate,            :except => [ 'show', 'register']
  before_filter :authenticate_with_admin, :except => [ 'show', 'register']

  before_action :set_event, only: [ :show, :edit, :update, :destroy, :publish, :register, :admin_view, :add_organizer, :remove_organizer ]

  def index
    @events = Event.by_recent.paginate page: params[:page], per_page: 20
    switch_to_admin_layout
  end

  def admin_view
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
    registration = Registration.create event_id: @event.id, registrant_id: current_user.id
    if registration
      Activity.create doer_id: current_user.id, message: "registered for the event entitled: #{view_context.link_to @event.short_name, @event}"
      send_confirmation_email
      redirect_to @event, notice: "<span class='glyphicon glyphicon-heart'></span> <strong>Success</strong> You have been registered for this event. Check your email inbox or spam folder for your official confirmation.".html_safe
    else
      redirect_to @event, warning: "<span class='glyphicon glyphicon-exclamation-sign'></span> <strong>Attention</strong> There was a problem recording your registration. Please try again.".html_safe
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit( :name, :nickname, :description, :body, :starts_at, :price, :maximum_number_of_registrants, :confirmation_emails_text, :confirmation_emails_html, :published )
    end

    def send_confirmation_email
      begin
        EventMailer.confirmation(current_user, @event).deliver_now
      rescue Exception => e
        AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send an event confirmation email.").deliver_now
      end
    end
end
