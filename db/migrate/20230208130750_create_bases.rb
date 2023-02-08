class CreateBases < ActiveRecord::Migration[5.1]
  def change
    create_table :bases do |t|
      t.integer :base_namber    #拠点番号
      t.string :base_name       #拠点名
      t.string :attendance_type #勤怠種類

    end
  end
end
