class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    drope_table :students do |t|

      t.timestamps
    end
  end
end
