class AddTinyNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :tiny_name, :string
  end
end
