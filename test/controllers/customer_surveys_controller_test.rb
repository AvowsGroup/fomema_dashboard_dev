require 'test_helper'

class CustomerSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_survey = customer_surveys(:one)
  end

  test "should get index" do
    get customer_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_survey_url
    assert_response :success
  end

  test "should create customer_survey" do
    assert_difference('CustomerSurvey.count') do
      post customer_surveys_url, params: { customer_survey: { collector_id: @customer_survey.collector_id, custom_data: @customer_survey.custom_data, email_address: @customer_survey.email_address, end_date: @customer_survey.end_date, first_name: @customer_survey.first_name, how_do_you_reachus: @customer_survey.how_do_you_reachus, how_long_did_you_wait: @customer_survey.how_long_did_you_wait, how_would_you_rate: @customer_survey.how_would_you_rate, ip_address: @customer_survey.ip_address, is_this_issue_or_problem: @customer_survey.is_this_issue_or_problem, last_name: @customer_survey.last_name, overall_how_satisfied_are_you: @customer_survey.overall_how_satisfied_are_you, respondent_id: @customer_survey.respondent_id, start_date: @customer_survey.start_date, what_is_customer_suits_you: @customer_survey.what_is_customer_suits_you, what_is_your_age: @customer_survey.what_is_your_age, what_is_your_email_address: @customer_survey.what_is_your_email_address, what_is_your_gender: @customer_survey.what_is_your_gender } }
    end

    assert_redirected_to customer_survey_url(CustomerSurvey.last)
  end

  test "should show customer_survey" do
    get customer_survey_url(@customer_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_survey_url(@customer_survey)
    assert_response :success
  end

  test "should update customer_survey" do
    patch customer_survey_url(@customer_survey), params: { customer_survey: { collector_id: @customer_survey.collector_id, custom_data: @customer_survey.custom_data, email_address: @customer_survey.email_address, end_date: @customer_survey.end_date, first_name: @customer_survey.first_name, how_do_you_reachus: @customer_survey.how_do_you_reachus, how_long_did_you_wait: @customer_survey.how_long_did_you_wait, how_would_you_rate: @customer_survey.how_would_you_rate, ip_address: @customer_survey.ip_address, is_this_issue_or_problem: @customer_survey.is_this_issue_or_problem, last_name: @customer_survey.last_name, overall_how_satisfied_are_you: @customer_survey.overall_how_satisfied_are_you, respondent_id: @customer_survey.respondent_id, start_date: @customer_survey.start_date, what_is_customer_suits_you: @customer_survey.what_is_customer_suits_you, what_is_your_age: @customer_survey.what_is_your_age, what_is_your_email_address: @customer_survey.what_is_your_email_address, what_is_your_gender: @customer_survey.what_is_your_gender } }
    assert_redirected_to customer_survey_url(@customer_survey)
  end

  test "should destroy customer_survey" do
    assert_difference('CustomerSurvey.count', -1) do
      delete customer_survey_url(@customer_survey)
    end

    assert_redirected_to customer_surveys_url
  end
end
