class CreateSurveyMonkeys < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_monkeys do |t|
      t.string :respondent_id
      t.string :collector_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :ip_address
      t.string :email_address
      t.string :first_name
      t.string :last_name
      t.string :custom_data
      t.string :what_is_your_email_address
      t.string :what_is_your_gender
      t.string :what_is_your_age
      t.string :what_is_customer_suits_you
      t.string :how_do_you_reachus
      t.string :how_long_did_you_wait
      t.string :is_this_issue_or_problem
      t.string :how_would_you_rate
      t.string :overall_how_satisfied_are_you

      t.timestamps
    end
  end
end
