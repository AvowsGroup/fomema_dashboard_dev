require 'test_helper'

class LaboratoryExaminationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @laboratory_examination = laboratory_examinations(:one)
  end

  test "should get index" do
    get laboratory_examinations_url
    assert_response :success
  end

  test "should get new" do
    get new_laboratory_examination_url
    assert_response :success
  end

  test "should create laboratory_examination" do
    assert_difference('LaboratoryExamination.count') do
      post laboratory_examinations_url, params: { laboratory_examination: { blood_group: @laboratory_examination.blood_group, blood_group_rhesus: @laboratory_examination.blood_group_rhesus, blood_specimen_barcode: @laboratory_examination.blood_specimen_barcode, created_by: @laboratory_examination.created_by, deleted_at: @laboratory_examination.deleted_at, laboratory_id: @laboratory_examination.laboratory_id, laboratory_test_not_done: @laboratory_examination.laboratory_test_not_done, result: @laboratory_examination.result, specimen_received_date: @laboratory_examination.specimen_received_date, specimen_taken_date: @laboratory_examination.specimen_taken_date, transaction_id: @laboratory_examination.transaction_id, transmitted_at: @laboratory_examination.transmitted_at, updated_by: @laboratory_examination.updated_by, urine_specimen_barcode: @laboratory_examination.urine_specimen_barcode, web_service_indicator: @laboratory_examination.web_service_indicator } }
    end

    assert_redirected_to laboratory_examination_url(LaboratoryExamination.last)
  end

  test "should show laboratory_examination" do
    get laboratory_examination_url(@laboratory_examination)
    assert_response :success
  end

  test "should get edit" do
    get edit_laboratory_examination_url(@laboratory_examination)
    assert_response :success
  end

  test "should update laboratory_examination" do
    patch laboratory_examination_url(@laboratory_examination), params: { laboratory_examination: { blood_group: @laboratory_examination.blood_group, blood_group_rhesus: @laboratory_examination.blood_group_rhesus, blood_specimen_barcode: @laboratory_examination.blood_specimen_barcode, created_by: @laboratory_examination.created_by, deleted_at: @laboratory_examination.deleted_at, laboratory_id: @laboratory_examination.laboratory_id, laboratory_test_not_done: @laboratory_examination.laboratory_test_not_done, result: @laboratory_examination.result, specimen_received_date: @laboratory_examination.specimen_received_date, specimen_taken_date: @laboratory_examination.specimen_taken_date, transaction_id: @laboratory_examination.transaction_id, transmitted_at: @laboratory_examination.transmitted_at, updated_by: @laboratory_examination.updated_by, urine_specimen_barcode: @laboratory_examination.urine_specimen_barcode, web_service_indicator: @laboratory_examination.web_service_indicator } }
    assert_redirected_to laboratory_examination_url(@laboratory_examination)
  end

  test "should destroy laboratory_examination" do
    assert_difference('LaboratoryExamination.count', -1) do
      delete laboratory_examination_url(@laboratory_examination)
    end

    assert_redirected_to laboratory_examinations_url
  end
end
