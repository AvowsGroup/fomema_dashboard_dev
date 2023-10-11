require 'test_helper'

class StatusSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_schedule = status_schedules(:one)
  end

  test "should get index" do
    get status_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_status_schedule_url
    assert_response :success
  end

  test "should create status_schedule" do
    assert_difference('StatusSchedule.count') do
      post status_schedules_url, params: { status_schedule: { comment: @status_schedule.comment, created_by: @status_schedule.created_by, from: @status_schedule.from, previous_comment: @status_schedule.previous_comment, previous_status: @status_schedule.previous_status, previous_status_reason: @status_schedule.previous_status_reason, status: @status_schedule.status, status_reason: @status_schedule.status_reason, status_scheduleable_id: @status_schedule.status_scheduleable_id, status_scheduleable_type: @status_schedule.status_scheduleable_type, to: @status_schedule.to, updated_by: @status_schedule.updated_by } }
    end

    assert_redirected_to status_schedule_url(StatusSchedule.last)
  end

  test "should show status_schedule" do
    get status_schedule_url(@status_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_schedule_url(@status_schedule)
    assert_response :success
  end

  test "should update status_schedule" do
    patch status_schedule_url(@status_schedule), params: { status_schedule: { comment: @status_schedule.comment, created_by: @status_schedule.created_by, from: @status_schedule.from, previous_comment: @status_schedule.previous_comment, previous_status: @status_schedule.previous_status, previous_status_reason: @status_schedule.previous_status_reason, status: @status_schedule.status, status_reason: @status_schedule.status_reason, status_scheduleable_id: @status_schedule.status_scheduleable_id, status_scheduleable_type: @status_schedule.status_scheduleable_type, to: @status_schedule.to, updated_by: @status_schedule.updated_by } }
    assert_redirected_to status_schedule_url(@status_schedule)
  end

  test "should destroy status_schedule" do
    assert_difference('StatusSchedule.count', -1) do
      delete status_schedule_url(@status_schedule)
    end

    assert_redirected_to status_schedules_url
  end
end
