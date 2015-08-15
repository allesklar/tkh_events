class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :event_id
      t.integer :registrant_id

      t.timestamps
    end
    add_index :registrations, :event_id
    add_index :registrations, :registrant_id

    # add registration related fields to events table
    add_column :events, :price, :integer
    add_column :events, :maximum_number_of_registrants, :integer, default: 0
    add_column :events, :confirmation_emails_text, :text
    add_column :events, :confirmation_emails_html, :text
  end
end
