require 'prawn/table'

class AttendanceListPdf < Prawn::Document

  def initialize(event, registrants)
    super({ page_size: 'A4' })
    @event, @registrants = event, registrants
    # define embedded fonts
    font_families.update(
      "OpenSans Condensed" => {
        normal: "#{Rails.root}/app/assets/fonts/eventpdfs/opensans-condlight.ttf"
      },
      "OpenSans" => {
        normal: "#{Rails.root}/app/assets/fonts/eventpdfs/opensans-regular.ttf",
        bold:   "#{Rails.root}/app/assets/fonts/eventpdfs/opensans-semibold.ttf"
      } )
    header
    table_content
    # footer
  end

  def header
    # This inserts an image in the pdf file and sets the size of the image
    # image "#{Rails.root}/app/assets/images/admin/admin-logo.jpg"
    font "OpenSans Condensed" do
      text @event.name, align: :center, size: 32
      text "Starting: #{I18n.localize @event.starts_at, format: :tkh_default}", align: :center, size: 20
    end
  end

  def table_content
    move_down 22

    # data = [["id", "email", "first name", "last name", "payment", ""]]
    data = []
    data << [ "email", "first name", "last name", "paym."]

    @registrants.each do |r|
      data << [ r.email, r.first_name, r.last_name, '' ]
    end

    5.times do
      data << [ '', '', '', '' ]
    end

    font "OpenSans"
    font_size 10

    table data, header: true, column_widths: [ 155, 155, 155, 55 ] do

      row(0).font_size    = 12
      row(0).font_style   = :bold
      row(0).border_width = 2

      cells.border_color  = "999999"
      cells.height        = 45
      cells.border_width  = 1

    end

  end

  def footer
    move_down 20
    # This inserts an image in the pdf file and sets the size of the image
    image "#{Rails.root}/app/assets/images/admin/admin-logo.jpg"
  end

end
