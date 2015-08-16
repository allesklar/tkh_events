class Organizer < Member

  has_many :event_organizers
  has_many :events, through: :event_organizers

  scope :with_a_name, -> { where(" first_name <> '' AND last_name <> '' ") }

end
