require 'test_helper'

class SurveyMonkeyCustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey_monkey_customer = survey_monkey_customers(:one)
  end

  test "should get index" do
    get survey_monkey_customers_url
    assert_response :success
  end

  test "should get new" do
    get new_survey_monkey_customer_url
    assert_response :success
  end

  test "should create survey_monkey_customer" do
    assert_difference('SurveyMonkeyCustomer.count') do
      post survey_monkey_customers_url, params: { survey_monkey_customer: { Fomema_medical_examincation_are_understandable: @survey_monkey_customer.Fomema_medical_examincation_are_understandable, Other_medical: @survey_monkey_customer.Other_medical, Overall_rate_experience_medical_examination: @survey_monkey_customer.Overall_rate_experience_medical_examination, aligned_info_moh_MOHA: @survey_monkey_customer.aligned_info_moh_MOHA, announcement_business_operator: @survey_monkey_customer.announcement_business_operator, collector_id: @survey_monkey_customer.collector_id, custom_data: @survey_monkey_customer.custom_data, delivering_health: @survey_monkey_customer.delivering_health, email_address: @survey_monkey_customer.email_address, end_date: @survey_monkey_customer.end_date, facebook: @survey_monkey_customer.facebook, first_name: @survey_monkey_customer.first_name, how_do_you_reachus: @survey_monkey_customer.how_do_you_reachus, how_long_did_you_wait: @survey_monkey_customer.how_long_did_you_wait, how_would_you_rate: @survey_monkey_customer.how_would_you_rate, instagram: @survey_monkey_customer.instagram, ip_address: @survey_monkey_customer.ip_address, is_this_issue_or_problem: @survey_monkey_customer.is_this_issue_or_problem, last_name: @survey_monkey_customer.last_name, location_panel_clinics: @survey_monkey_customer.location_panel_clinics, medical_Examinations_are_easy_toobtain: @survey_monkey_customer.medical_Examinations_are_easy_toobtain, other: @survey_monkey_customer.other, other_appealprocess: @survey_monkey_customer.other_appealprocess, other_social: @survey_monkey_customer.other_social, overall_experience_reg_process: @survey_monkey_customer.overall_experience_reg_process, overall_how_satisfied_are_you: @survey_monkey_customer.overall_how_satisfied_are_you, panel_clinic_xray_facilities: @survey_monkey_customer.panel_clinic_xray_facilities, process_emp_reg: @survey_monkey_customer.process_emp_reg, process_worker_reg: @survey_monkey_customer.process_worker_reg, recommend_fomema_friend_collegue: @survey_monkey_customer.recommend_fomema_friend_collegue, respondent_id: @survey_monkey_customer.respondent_id, start_date: @survey_monkey_customer.start_date, telegram: @survey_monkey_customer.telegram, tell_experience_appeal_process: @survey_monkey_customer.tell_experience_appeal_process, twitter: @survey_monkey_customer.twitter, undergo_fomema_appeal_process: @survey_monkey_customer.undergo_fomema_appeal_process, what_is_customer_suits_you: @survey_monkey_customer.what_is_customer_suits_you, what_is_your_age: @survey_monkey_customer.what_is_your_age, what_is_your_email_address: @survey_monkey_customer.what_is_your_email_address, what_is_your_gender: @survey_monkey_customer.what_is_your_gender, what_tochange_fomema_socialmedia: @survey_monkey_customer.what_tochange_fomema_socialmedia, where_did_you_register_your_worker: @survey_monkey_customer.where_did_you_register_your_worker, which_sector_below_represents: @survey_monkey_customer.which_sector_below_represents, worker_status_found_medical_unsuitable: @survey_monkey_customer.worker_status_found_medical_unsuitable } }
    end

    assert_redirected_to survey_monkey_customer_url(SurveyMonkeyCustomer.last)
  end

  test "should show survey_monkey_customer" do
    get survey_monkey_customer_url(@survey_monkey_customer)
    assert_response :success
  end

  test "should get edit" do
    get edit_survey_monkey_customer_url(@survey_monkey_customer)
    assert_response :success
  end

  test "should update survey_monkey_customer" do
    patch survey_monkey_customer_url(@survey_monkey_customer), params: { survey_monkey_customer: { Fomema_medical_examincation_are_understandable: @survey_monkey_customer.Fomema_medical_examincation_are_understandable, Other_medical: @survey_monkey_customer.Other_medical, Overall_rate_experience_medical_examination: @survey_monkey_customer.Overall_rate_experience_medical_examination, aligned_info_moh_MOHA: @survey_monkey_customer.aligned_info_moh_MOHA, announcement_business_operator: @survey_monkey_customer.announcement_business_operator, collector_id: @survey_monkey_customer.collector_id, custom_data: @survey_monkey_customer.custom_data, delivering_health: @survey_monkey_customer.delivering_health, email_address: @survey_monkey_customer.email_address, end_date: @survey_monkey_customer.end_date, facebook: @survey_monkey_customer.facebook, first_name: @survey_monkey_customer.first_name, how_do_you_reachus: @survey_monkey_customer.how_do_you_reachus, how_long_did_you_wait: @survey_monkey_customer.how_long_did_you_wait, how_would_you_rate: @survey_monkey_customer.how_would_you_rate, instagram: @survey_monkey_customer.instagram, ip_address: @survey_monkey_customer.ip_address, is_this_issue_or_problem: @survey_monkey_customer.is_this_issue_or_problem, last_name: @survey_monkey_customer.last_name, location_panel_clinics: @survey_monkey_customer.location_panel_clinics, medical_Examinations_are_easy_toobtain: @survey_monkey_customer.medical_Examinations_are_easy_toobtain, other: @survey_monkey_customer.other, other_appealprocess: @survey_monkey_customer.other_appealprocess, other_social: @survey_monkey_customer.other_social, overall_experience_reg_process: @survey_monkey_customer.overall_experience_reg_process, overall_how_satisfied_are_you: @survey_monkey_customer.overall_how_satisfied_are_you, panel_clinic_xray_facilities: @survey_monkey_customer.panel_clinic_xray_facilities, process_emp_reg: @survey_monkey_customer.process_emp_reg, process_worker_reg: @survey_monkey_customer.process_worker_reg, recommend_fomema_friend_collegue: @survey_monkey_customer.recommend_fomema_friend_collegue, respondent_id: @survey_monkey_customer.respondent_id, start_date: @survey_monkey_customer.start_date, telegram: @survey_monkey_customer.telegram, tell_experience_appeal_process: @survey_monkey_customer.tell_experience_appeal_process, twitter: @survey_monkey_customer.twitter, undergo_fomema_appeal_process: @survey_monkey_customer.undergo_fomema_appeal_process, what_is_customer_suits_you: @survey_monkey_customer.what_is_customer_suits_you, what_is_your_age: @survey_monkey_customer.what_is_your_age, what_is_your_email_address: @survey_monkey_customer.what_is_your_email_address, what_is_your_gender: @survey_monkey_customer.what_is_your_gender, what_tochange_fomema_socialmedia: @survey_monkey_customer.what_tochange_fomema_socialmedia, where_did_you_register_your_worker: @survey_monkey_customer.where_did_you_register_your_worker, which_sector_below_represents: @survey_monkey_customer.which_sector_below_represents, worker_status_found_medical_unsuitable: @survey_monkey_customer.worker_status_found_medical_unsuitable } }
    assert_redirected_to survey_monkey_customer_url(@survey_monkey_customer)
  end

  test "should destroy survey_monkey_customer" do
    assert_difference('SurveyMonkeyCustomer.count', -1) do
      delete survey_monkey_customer_url(@survey_monkey_customer)
    end

    assert_redirected_to survey_monkey_customers_url
  end
end
