class DepartmentConfiguration < ActiveRecord::Migration[5.2]
  def change
    create_table :department_configurations do |t|
      t.string :category
      t.string :task
      t.string :approver
      t.string :tat
      t.string :target
      t.float :kpi
      t.string :action
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
