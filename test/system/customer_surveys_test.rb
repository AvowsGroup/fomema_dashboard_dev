require "application_system_test_case"

class CustomerSurveysTest < ApplicationSystemTestCase
  setup do
    @customer_survey = customer_surveys(:one)
  end

  test "visiting the index" do
    visit customer_surveys_url
    assert_selector "h1", text: "Customer Surveys"
  end

  test "creating a Customer survey" do
    visit customer_surveys_url
    click_on "New Customer Survey"

    fill_in "Collector", with: @customer_survey.collector_id
    fill_in "Custom data", with: @customer_survey.custom_data
    fill_in "Email address", with: @customer_survey.email_address
    fill_in "End date", with: @customer_survey.end_date
    fill_in "First name", with: @customer_survey.first_name
    fill_in "How do you reachus", with: @customer_survey.how_do_you_reachus
    fill_in "How long did you wait", with: @customer_survey.how_long_did_you_wait
    fill_in "How would you rate", with: @customer_survey.how_would_you_rate
    fill_in "Ip address", with: @customer_survey.ip_address
    fill_in "Is this issue or problem", with: @customer_survey.is_this_issue_or_problem
    fill_in "Last name", with: @customer_survey.last_name
    fill_in "Overall how satisfied are you", with: @customer_survey.overall_how_satisfied_are_you
    fill_in "Respondent", with: @customer_survey.respondent_id
    fill_in "Start date", with: @customer_survey.start_date
    fill_in "What is customer suits you", with: @customer_survey.what_is_customer_suits_you
    fill_in "What is your age", with: @customer_survey.what_is_your_age
    fill_in "What is your email address", with: @customer_survey.what_is_your_email_address
    fill_in "What is your gender", with: @customer_survey.what_is_your_gender
    click_on "Create Customer survey"

    assert_text "Customer survey was successfully created"
    click_on "Back"
  end

  test "updating a Customer survey" do
    visit customer_surveys_url
    click_on "Edit", match: :first

    fill_in "Collector", with: @customer_survey.collector_id
    fill_in "Custom data", with: @customer_survey.custom_data
    fill_in "Email address", with: @customer_survey.email_address
    fill_in "End date", with: @customer_survey.end_date
    fill_in "First name", with: @customer_survey.first_name
    fill_in "How do you reachus", with: @customer_survey.how_do_you_reachus
    fill_in "How long did you wait", with: @customer_survey.how_long_did_you_wait
    fill_in "How would you rate", with: @customer_survey.how_would_you_rate
    fill_in "Ip address", with: @customer_survey.ip_address
    fill_in "Is this issue or problem", with: @customer_survey.is_this_issue_or_problem
    fill_in "Last name", with: @customer_survey.last_name
    fill_in "Overall how satisfied are you", with: @customer_survey.overall_how_satisfied_are_you
    fill_in "Respondent", with: @customer_survey.respondent_id
    fill_in "Start date", with: @customer_survey.start_date
    fill_in "What is customer suits you", with: @customer_survey.what_is_customer_suits_you
    fill_in "What is your age", with: @customer_survey.what_is_your_age
    fill_in "What is your email address", with: @customer_survey.what_is_your_email_address
    fill_in "What is your gender", with: @customer_survey.what_is_your_gender
    click_on "Update Customer survey"

    assert_text "Customer survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer survey" do
    visit customer_surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer survey was successfully destroyed"
  end
end
