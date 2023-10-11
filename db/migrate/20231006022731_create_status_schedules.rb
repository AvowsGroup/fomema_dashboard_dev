class CreateStatusSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :status_schedules do |t|
      t.string :status_scheduleable_type
      t.bigint :status_scheduleable_id
      t.date :from
      t.date :to
      t.string :status
      t.string :status_reason
      t.text :comment
      t.string :previous_status
      t.string :previous_status_reason
      t.bigint :created_by
      t.bigint :updated_by
      t.text :previous_comment

      t.timestamps
    end
  end
end
