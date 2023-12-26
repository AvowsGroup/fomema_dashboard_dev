class CreateAuditLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :audit_logs do |t|
      t.integer :user_id
      t.string :version
      t.string :name
      t.string :changed_fields
      t.string :action
      t.timestamps
    end
  end
end

