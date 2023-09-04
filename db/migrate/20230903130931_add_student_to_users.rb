class AddStudentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :student_number, :integer
    add_column :users, :student, :boolean, default: false
  end
end
