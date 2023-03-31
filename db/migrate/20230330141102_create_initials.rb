class CreateInitials < ActiveRecord::Migration[5.1]
  def change
    create_table :initials do |t|
      t.timestamps
    end
  end
end
