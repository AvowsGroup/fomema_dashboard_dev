require "application_system_test_case"

class StatusSchedulesTest < ApplicationSystemTestCase
  setup do
    @status_schedule = status_schedules(:one)
  end

  test "visiting the index" do
    visit status_schedules_url
    assert_selector "h1", text: "Status Schedules"
  end

  test "creating a Status schedule" do
    visit status_schedules_url
    click_on "New Status Schedule"

    fill_in "Comment", with: @status_schedule.comment
    fill_in "Created by", with: @status_schedule.created_by
    fill_in "From", with: @status_schedule.from
    fill_in "Previous comment", with: @status_schedule.previous_comment
    fill_in "Previous status", with: @status_schedule.previous_status
    fill_in "Previous status reason", with: @status_schedule.previous_status_reason
    fill_in "Status", with: @status_schedule.status
    fill_in "Status reason", with: @status_schedule.status_reason
    fill_in "Status scheduleable", with: @status_schedule.status_scheduleable_id
    fill_in "Status scheduleable type", with: @status_schedule.status_scheduleable_type
    fill_in "To", with: @status_schedule.to
    fill_in "Updated by", with: @status_schedule.updated_by
    click_on "Create Status schedule"

    assert_text "Status schedule was successfully created"
    click_on "Back"
  end

  test "updating a Status schedule" do
    visit status_schedules_url
    click_on "Edit", match: :first

    fill_in "Comment", with: @status_schedule.comment
    fill_in "Created by", with: @status_schedule.created_by
    fill_in "From", with: @status_schedule.from
    fill_in "Previous comment", with: @status_schedule.previous_comment
    fill_in "Previous status", with: @status_schedule.previous_status
    fill_in "Previous status reason", with: @status_schedule.previous_status_reason
    fill_in "Status", with: @status_schedule.status
    fill_in "Status reason", with: @status_schedule.status_reason
    fill_in "Status scheduleable", with: @status_schedule.status_scheduleable_id
    fill_in "Status scheduleable type", with: @status_schedule.status_scheduleable_type
    fill_in "To", with: @status_schedule.to
    fill_in "Updated by", with: @status_schedule.updated_by
    click_on "Update Status schedule"

    assert_text "Status schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Status schedule" do
    visit status_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status schedule was successfully destroyed"
  end
end
