class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :day_identifier
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
