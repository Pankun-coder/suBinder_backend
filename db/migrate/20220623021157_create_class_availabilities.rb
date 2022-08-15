class CreateClassAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :class_availabilities do |t|
      t.datetime :from
      t.datetime :to
      t.references :group, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.timestamps
    end
  end
end
