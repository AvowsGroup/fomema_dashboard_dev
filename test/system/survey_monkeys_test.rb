require "application_system_test_case"

class SurveyMonkeysTest < ApplicationSystemTestCase
  setup do
    @survey_monkey = survey_monkeys(:one)
  end

  test "visiting the index" do
    visit survey_monkeys_url
    assert_selector "h1", text: "Survey Monkeys"
  end

  test "creating a Survey monkey" do
    visit survey_monkeys_url
    click_on "New Survey Monkey"

    fill_in "Collector", with: @survey_monkey.collector_id
    fill_in "Custom data", with: @survey_monkey.custom_data
    fill_in "Email address", with: @survey_monkey.email_address
    fill_in "End date", with: @survey_monkey.end_date
    fill_in "First name", with: @survey_monkey.first_name
    fill_in "How do you reachus", with: @survey_monkey.how_do_you_reachus
    fill_in "How long did you wait", with: @survey_monkey.how_long_did_you_wait
    fill_in "How would you rate", with: @survey_monkey.how_would_you_rate
    fill_in "Ip address", with: @survey_monkey.ip_address
    fill_in "Is this issue or problem", with: @survey_monkey.is_this_issue_or_problem
    fill_in "Last name", with: @survey_monkey.last_name
    fill_in "Overall how satisfied are you", with: @survey_monkey.overall_how_satisfied_are_you
    fill_in "Respondent", with: @survey_monkey.respondent_id
    fill_in "Start date", with: @survey_monkey.start_date
    fill_in "What is customer suits you", with: @survey_monkey.what_is_customer_suits_you
    fill_in "What is your age", with: @survey_monkey.what_is_your_age
    fill_in "What is your email address", with: @survey_monkey.what_is_your_email_address
    fill_in "What is your gender", with: @survey_monkey.what_is_your_gender
    click_on "Create Survey monkey"

    assert_text "Survey monkey was successfully created"
    click_on "Back"
  end

  test "updating a Survey monkey" do
    visit survey_monkeys_url
    click_on "Edit", match: :first

    fill_in "Collector", with: @survey_monkey.collector_id
    fill_in "Custom data", with: @survey_monkey.custom_data
    fill_in "Email address", with: @survey_monkey.email_address
    fill_in "End date", with: @survey_monkey.end_date
    fill_in "First name", with: @survey_monkey.first_name
    fill_in "How do you reachus", with: @survey_monkey.how_do_you_reachus
    fill_in "How long did you wait", with: @survey_monkey.how_long_did_you_wait
    fill_in "How would you rate", with: @survey_monkey.how_would_you_rate
    fill_in "Ip address", with: @survey_monkey.ip_address
    fill_in "Is this issue or problem", with: @survey_monkey.is_this_issue_or_problem
    fill_in "Last name", with: @survey_monkey.last_name
    fill_in "Overall how satisfied are you", with: @survey_monkey.overall_how_satisfied_are_you
    fill_in "Respondent", with: @survey_monkey.respondent_id
    fill_in "Start date", with: @survey_monkey.start_date
    fill_in "What is customer suits you", with: @survey_monkey.what_is_customer_suits_you
    fill_in "What is your age", with: @survey_monkey.what_is_your_age
    fill_in "What is your email address", with: @survey_monkey.what_is_your_email_address
    fill_in "What is your gender", with: @survey_monkey.what_is_your_gender
    click_on "Update Survey monkey"

    assert_text "Survey monkey was successfully updated"
    click_on "Back"
  end

  test "destroying a Survey monkey" do
    visit survey_monkeys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Survey monkey was successfully destroyed"
  end
end
