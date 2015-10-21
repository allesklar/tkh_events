class Registrant < Member

  has_many :registrations

  def name_or_email
    name.present? ? name : email
  end

end
