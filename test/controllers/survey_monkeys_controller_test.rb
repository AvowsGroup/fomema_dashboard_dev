require 'test_helper'

class SurveyMonkeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey_monkey = survey_monkeys(:one)
  end

  test "should get index" do
    get survey_monkeys_url
    assert_response :success
  end

  test "should get new" do
    get new_survey_monkey_url
    assert_response :success
  end

  test "should create survey_monkey" do
    assert_difference('SurveyMonkey.count') do
      post survey_monkeys_url, params: { survey_monkey: { collector_id: @survey_monkey.collector_id, custom_data: @survey_monkey.custom_data, email_address: @survey_monkey.email_address, end_date: @survey_monkey.end_date, first_name: @survey_monkey.first_name, how_do_you_reachus: @survey_monkey.how_do_you_reachus, how_long_did_you_wait: @survey_monkey.how_long_did_you_wait, how_would_you_rate: @survey_monkey.how_would_you_rate, ip_address: @survey_monkey.ip_address, is_this_issue_or_problem: @survey_monkey.is_this_issue_or_problem, last_name: @survey_monkey.last_name, overall_how_satisfied_are_you: @survey_monkey.overall_how_satisfied_are_you, respondent_id: @survey_monkey.respondent_id, start_date: @survey_monkey.start_date, what_is_customer_suits_you: @survey_monkey.what_is_customer_suits_you, what_is_your_age: @survey_monkey.what_is_your_age, what_is_your_email_address: @survey_monkey.what_is_your_email_address, what_is_your_gender: @survey_monkey.what_is_your_gender } }
    end

    assert_redirected_to survey_monkey_url(SurveyMonkey.last)
  end

  test "should show survey_monkey" do
    get survey_monkey_url(@survey_monkey)
    assert_response :success
  end

  test "should get edit" do
    get edit_survey_monkey_url(@survey_monkey)
    assert_response :success
  end

  test "should update survey_monkey" do
    patch survey_monkey_url(@survey_monkey), params: { survey_monkey: { collector_id: @survey_monkey.collector_id, custom_data: @survey_monkey.custom_data, email_address: @survey_monkey.email_address, end_date: @survey_monkey.end_date, first_name: @survey_monkey.first_name, how_do_you_reachus: @survey_monkey.how_do_you_reachus, how_long_did_you_wait: @survey_monkey.how_long_did_you_wait, how_would_you_rate: @survey_monkey.how_would_you_rate, ip_address: @survey_monkey.ip_address, is_this_issue_or_problem: @survey_monkey.is_this_issue_or_problem, last_name: @survey_monkey.last_name, overall_how_satisfied_are_you: @survey_monkey.overall_how_satisfied_are_you, respondent_id: @survey_monkey.respondent_id, start_date: @survey_monkey.start_date, what_is_customer_suits_you: @survey_monkey.what_is_customer_suits_you, what_is_your_age: @survey_monkey.what_is_your_age, what_is_your_email_address: @survey_monkey.what_is_your_email_address, what_is_your_gender: @survey_monkey.what_is_your_gender } }
    assert_redirected_to survey_monkey_url(@survey_monkey)
  end

  test "should destroy survey_monkey" do
    assert_difference('SurveyMonkey.count', -1) do
      delete survey_monkey_url(@survey_monkey)
    end

    assert_redirected_to survey_monkeys_url
  end
end
