class CreateRadiologists < ActiveRecord::Migration[5.2]
  def change
    create_table :radiologists do |t|
      t.string :code
      t.string :name
      t.string :xray_facility_name
      t.string :string
      t.bigint :title_id
      t.string :icno
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.bigint :country_id
      t.bigint :state_id
      t.bigint :town_id
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :mobile
      t.string :email
      t.string :qualification
      t.boolean :is_panel_xray_facility
      t.bigint :district_health_office_id
      t.boolean :is_pcr
      t.integer :apc_year
      t.string :apc_number
      t.string :nsr_number
      t.date :renewal_agreement_date
      t.text :comment
      t.string :status
      t.string :status_reason
      t.datetime :registration_approved_at
      t.datetime :activated_at
      t.string :approval_status
      t.string :approval_remark
      t.bigint :created_by
      t.bigint :updated_by
      t.text :status_comment
      t.bigint :user_id
      t.string :gender
      t.bigint :nationality_id
      t.bigint :race_id

      t.timestamps
    end
  end
end
