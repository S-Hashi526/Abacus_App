class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.integer :score #点数
      t.string :subject #科目
      t.date :date #日付
    end
  end
end
