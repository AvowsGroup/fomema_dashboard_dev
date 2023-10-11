require "application_system_test_case"

class SurveyMonkeyCustomersTest < ApplicationSystemTestCase
  setup do
    @survey_monkey_customer = survey_monkey_customers(:one)
  end

  test "visiting the index" do
    visit survey_monkey_customers_url
    assert_selector "h1", text: "Survey Monkey Customers"
  end

  test "creating a Survey monkey customer" do
    visit survey_monkey_customers_url
    click_on "New Survey Monkey Customer"

    fill_in "Fomema medical examincation are understandable", with: @survey_monkey_customer.Fomema_medical_examincation_are_understandable
    fill_in "Other medical", with: @survey_monkey_customer.Other_medical
    fill_in "Overall rate experience medical examination", with: @survey_monkey_customer.Overall_rate_experience_medical_examination
    fill_in "Aligned info moh moha", with: @survey_monkey_customer.aligned_info_moh_MOHA
    fill_in "Announcement business operator", with: @survey_monkey_customer.announcement_business_operator
    fill_in "Collector", with: @survey_monkey_customer.collector_id
    fill_in "Custom data", with: @survey_monkey_customer.custom_data
    fill_in "Delivering health", with: @survey_monkey_customer.delivering_health
    fill_in "Email address", with: @survey_monkey_customer.email_address
    fill_in "End date", with: @survey_monkey_customer.end_date
    fill_in "Facebook", with: @survey_monkey_customer.facebook
    fill_in "First name", with: @survey_monkey_customer.first_name
    fill_in "How do you reachus", with: @survey_monkey_customer.how_do_you_reachus
    fill_in "How long did you wait", with: @survey_monkey_customer.how_long_did_you_wait
    fill_in "How would you rate", with: @survey_monkey_customer.how_would_you_rate
    fill_in "Instagram", with: @survey_monkey_customer.instagram
    fill_in "Ip address", with: @survey_monkey_customer.ip_address
    fill_in "Is this issue or problem", with: @survey_monkey_customer.is_this_issue_or_problem
    fill_in "Last name", with: @survey_monkey_customer.last_name
    fill_in "Location panel clinics", with: @survey_monkey_customer.location_panel_clinics
    fill_in "Medical examinations are easy toobtain", with: @survey_monkey_customer.medical_Examinations_are_easy_toobtain
    fill_in "Other", with: @survey_monkey_customer.other
    fill_in "Other appealprocess", with: @survey_monkey_customer.other_appealprocess
    fill_in "Other social", with: @survey_monkey_customer.other_social
    fill_in "Overall experience reg process", with: @survey_monkey_customer.overall_experience_reg_process
    fill_in "Overall how satisfied are you", with: @survey_monkey_customer.overall_how_satisfied_are_you
    fill_in "Panel clinic xray facilities", with: @survey_monkey_customer.panel_clinic_xray_facilities
    fill_in "Process emp reg", with: @survey_monkey_customer.process_emp_reg
    fill_in "Process worker reg", with: @survey_monkey_customer.process_worker_reg
    fill_in "Recommend fomema friend collegue", with: @survey_monkey_customer.recommend_fomema_friend_collegue
    fill_in "Respondent", with: @survey_monkey_customer.respondent_id
    fill_in "Start date", with: @survey_monkey_customer.start_date
    fill_in "Telegram", with: @survey_monkey_customer.telegram
    fill_in "Tell experience appeal process", with: @survey_monkey_customer.tell_experience_appeal_process
    fill_in "Twitter", with: @survey_monkey_customer.twitter
    fill_in "Undergo fomema appeal process", with: @survey_monkey_customer.undergo_fomema_appeal_process
    fill_in "What is customer suits you", with: @survey_monkey_customer.what_is_customer_suits_you
    fill_in "What is your age", with: @survey_monkey_customer.what_is_your_age
    fill_in "What is your email address", with: @survey_monkey_customer.what_is_your_email_address
    fill_in "What is your gender", with: @survey_monkey_customer.what_is_your_gender
    fill_in "What tochange fomema socialmedia", with: @survey_monkey_customer.what_tochange_fomema_socialmedia
    fill_in "Where did you register your worker", with: @survey_monkey_customer.where_did_you_register_your_worker
    fill_in "Which sector below represents", with: @survey_monkey_customer.which_sector_below_represents
    fill_in "Worker status found medical unsuitable", with: @survey_monkey_customer.worker_status_found_medical_unsuitable
    click_on "Create Survey monkey customer"

    assert_text "Survey monkey customer was successfully created"
    click_on "Back"
  end

  test "updating a Survey monkey customer" do
    visit survey_monkey_customers_url
    click_on "Edit", match: :first

    fill_in "Fomema medical examincation are understandable", with: @survey_monkey_customer.Fomema_medical_examincation_are_understandable
    fill_in "Other medical", with: @survey_monkey_customer.Other_medical
    fill_in "Overall rate experience medical examination", with: @survey_monkey_customer.Overall_rate_experience_medical_examination
    fill_in "Aligned info moh moha", with: @survey_monkey_customer.aligned_info_moh_MOHA
    fill_in "Announcement business operator", with: @survey_monkey_customer.announcement_business_operator
    fill_in "Collector", with: @survey_monkey_customer.collector_id
    fill_in "Custom data", with: @survey_monkey_customer.custom_data
    fill_in "Delivering health", with: @survey_monkey_customer.delivering_health
    fill_in "Email address", with: @survey_monkey_customer.email_address
    fill_in "End date", with: @survey_monkey_customer.end_date
    fill_in "Facebook", with: @survey_monkey_customer.facebook
    fill_in "First name", with: @survey_monkey_customer.first_name
    fill_in "How do you reachus", with: @survey_monkey_customer.how_do_you_reachus
    fill_in "How long did you wait", with: @survey_monkey_customer.how_long_did_you_wait
    fill_in "How would you rate", with: @survey_monkey_customer.how_would_you_rate
    fill_in "Instagram", with: @survey_monkey_customer.instagram
    fill_in "Ip address", with: @survey_monkey_customer.ip_address
    fill_in "Is this issue or problem", with: @survey_monkey_customer.is_this_issue_or_problem
    fill_in "Last name", with: @survey_monkey_customer.last_name
    fill_in "Location panel clinics", with: @survey_monkey_customer.location_panel_clinics
    fill_in "Medical examinations are easy toobtain", with: @survey_monkey_customer.medical_Examinations_are_easy_toobtain
    fill_in "Other", with: @survey_monkey_customer.other
    fill_in "Other appealprocess", with: @survey_monkey_customer.other_appealprocess
    fill_in "Other social", with: @survey_monkey_customer.other_social
    fill_in "Overall experience reg process", with: @survey_monkey_customer.overall_experience_reg_process
    fill_in "Overall how satisfied are you", with: @survey_monkey_customer.overall_how_satisfied_are_you
    fill_in "Panel clinic xray facilities", with: @survey_monkey_customer.panel_clinic_xray_facilities
    fill_in "Process emp reg", with: @survey_monkey_customer.process_emp_reg
    fill_in "Process worker reg", with: @survey_monkey_customer.process_worker_reg
    fill_in "Recommend fomema friend collegue", with: @survey_monkey_customer.recommend_fomema_friend_collegue
    fill_in "Respondent", with: @survey_monkey_customer.respondent_id
    fill_in "Start date", with: @survey_monkey_customer.start_date
    fill_in "Telegram", with: @survey_monkey_customer.telegram
    fill_in "Tell experience appeal process", with: @survey_monkey_customer.tell_experience_appeal_process
    fill_in "Twitter", with: @survey_monkey_customer.twitter
    fill_in "Undergo fomema appeal process", with: @survey_monkey_customer.undergo_fomema_appeal_process
    fill_in "What is customer suits you", with: @survey_monkey_customer.what_is_customer_suits_you
    fill_in "What is your age", with: @survey_monkey_customer.what_is_your_age
    fill_in "What is your email address", with: @survey_monkey_customer.what_is_your_email_address
    fill_in "What is your gender", with: @survey_monkey_customer.what_is_your_gender
    fill_in "What tochange fomema socialmedia", with: @survey_monkey_customer.what_tochange_fomema_socialmedia
    fill_in "Where did you register your worker", with: @survey_monkey_customer.where_did_you_register_your_worker
    fill_in "Which sector below represents", with: @survey_monkey_customer.which_sector_below_represents
    fill_in "Worker status found medical unsuitable", with: @survey_monkey_customer.worker_status_found_medical_unsuitable
    click_on "Update Survey monkey customer"

    assert_text "Survey monkey customer was successfully updated"
    click_on "Back"
  end

  test "destroying a Survey monkey customer" do
    visit survey_monkey_customers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Survey monkey customer was successfully destroyed"
  end
end
