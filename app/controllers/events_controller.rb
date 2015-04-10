class EventsController < ApplicationController

  before_filter :authenticate, :except => 'show'
  before_filter :authenticate_with_admin, :except => 'show'

  before_action :set_event, only: [ :show, :edit, :update, :destroy, :publish ]

  def index
    @events = Event.by_recent
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :body, :starts_at, :published)
    end
end
