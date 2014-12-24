class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.text :body
      t.datetime :starts_at
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
