class Registration < ActiveRecord::Base

  belongs_to :event
  belongs_to :registrant, touch: true

  scope :by_recent, -> { order_by('updated_at desc') }

end
