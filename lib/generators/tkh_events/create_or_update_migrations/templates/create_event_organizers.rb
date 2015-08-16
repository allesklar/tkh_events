class CreateEventOrganizers < ActiveRecord::Migration
  def change
    create_table :event_organizers do |t|
      t.integer :event_id
      t.integer :organizer_id
      t.timestamps
    end
    add_index :event_organizers, :event_id
  end
end
