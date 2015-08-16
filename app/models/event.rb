class Event < ActiveRecord::Base

  has_many :event_organizers
  has_many :organizers, through: :event_organizers

  has_many :registrations
  has_many :registrants, through: :registrations

  attr_reader(:organizer_id) # to be used in the add_organizer_to_event_form partial

  tkh_searchable
  def self.tkh_search_indexable_fields
    indexable_fields = {
      name: 8,
      description: 3,
      body: 2
    }
  end

  def to_param
    name ? "#{id}-#{name.to_url}" : id
  end

  scope :published, -> { where( published: true ) }
  scope :in_the_future, -> { where( 'starts_at >= ?', Time.zone.now.beginning_of_day ) }
  scope :chronologically, -> { order 'starts_at' }
  scope :by_recent, -> { order('updated_at desc') }

  def short_name
    nickname || name || "no name given"
  end

  def self.duplicate( source_event_id )
    old_event = find( source_event_id )
    new_event = old_event.dup
    new_event.name = "Copy of #{old_event.name}"
    new_event.save
  end

end
