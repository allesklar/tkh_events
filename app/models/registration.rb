class Registration < ActiveRecord::Base

  belongs_to :event, touch: true
  belongs_to :registrant, touch: true

  scope :by_recent, -> { order_by('updated_at desc') }

  ### autocomplete related instance methods
  def registrant_email
    registrant.try(:email)
  end
  def registrant_email=(email)
    self.registrant_id = Registrant.where("email = ?", email).first.id
  end

end
