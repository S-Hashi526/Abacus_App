class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.integer :score #点数
      t.string :subject #科目
      t.date :date #日付
      t.references :student, foreign_key: true #生徒との関係
    end
  end
end
