class EventOrganizer < ActiveRecord::Base

  belongs_to :event
  belongs_to :organizer

  validates_presence_of :event_id
  validates_presence_of :organizer_id

end
