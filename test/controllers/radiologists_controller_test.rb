require 'test_helper'

class RadiologistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @radiologist = radiologists(:one)
  end

  test "should get index" do
    get radiologists_url
    assert_response :success
  end

  test "should get new" do
    get new_radiologist_url
    assert_response :success
  end

  test "should create radiologist" do
    assert_difference('Radiologist.count') do
      post radiologists_url, params: { radiologist: { activated_at: @radiologist.activated_at, address1: @radiologist.address1, address2: @radiologist.address2, address3: @radiologist.address3, address4: @radiologist.address4, apc_number: @radiologist.apc_number, apc_year: @radiologist.apc_year, approval_remark: @radiologist.approval_remark, approval_status: @radiologist.approval_status, code: @radiologist.code, comment: @radiologist.comment, country_id: @radiologist.country_id, created_by: @radiologist.created_by, district_health_office_id: @radiologist.district_health_office_id, email: @radiologist.email, fax: @radiologist.fax, gender: @radiologist.gender, icno: @radiologist.icno, is_panel_xray_facility: @radiologist.is_panel_xray_facility, is_pcr: @radiologist.is_pcr, mobile: @radiologist.mobile, name: @radiologist.name, nationality_id: @radiologist.nationality_id, nsr_number: @radiologist.nsr_number, phone: @radiologist.phone, postcode: @radiologist.postcode, qualification: @radiologist.qualification, race_id: @radiologist.race_id, registration_approved_at: @radiologist.registration_approved_at, renewal_agreement_date: @radiologist.renewal_agreement_date, state_id: @radiologist.state_id, status: @radiologist.status, status_comment: @radiologist.status_comment, status_reason: @radiologist.status_reason, string: @radiologist.string, title_id: @radiologist.title_id, town_id: @radiologist.town_id, updated_by: @radiologist.updated_by, user_id: @radiologist.user_id, xray_facility_name: @radiologist.xray_facility_name } }
    end

    assert_redirected_to radiologist_url(Radiologist.last)
  end

  test "should show radiologist" do
    get radiologist_url(@radiologist)
    assert_response :success
  end

  test "should get edit" do
    get edit_radiologist_url(@radiologist)
    assert_response :success
  end

  test "should update radiologist" do
    patch radiologist_url(@radiologist), params: { radiologist: { activated_at: @radiologist.activated_at, address1: @radiologist.address1, address2: @radiologist.address2, address3: @radiologist.address3, address4: @radiologist.address4, apc_number: @radiologist.apc_number, apc_year: @radiologist.apc_year, approval_remark: @radiologist.approval_remark, approval_status: @radiologist.approval_status, code: @radiologist.code, comment: @radiologist.comment, country_id: @radiologist.country_id, created_by: @radiologist.created_by, district_health_office_id: @radiologist.district_health_office_id, email: @radiologist.email, fax: @radiologist.fax, gender: @radiologist.gender, icno: @radiologist.icno, is_panel_xray_facility: @radiologist.is_panel_xray_facility, is_pcr: @radiologist.is_pcr, mobile: @radiologist.mobile, name: @radiologist.name, nationality_id: @radiologist.nationality_id, nsr_number: @radiologist.nsr_number, phone: @radiologist.phone, postcode: @radiologist.postcode, qualification: @radiologist.qualification, race_id: @radiologist.race_id, registration_approved_at: @radiologist.registration_approved_at, renewal_agreement_date: @radiologist.renewal_agreement_date, state_id: @radiologist.state_id, status: @radiologist.status, status_comment: @radiologist.status_comment, status_reason: @radiologist.status_reason, string: @radiologist.string, title_id: @radiologist.title_id, town_id: @radiologist.town_id, updated_by: @radiologist.updated_by, user_id: @radiologist.user_id, xray_facility_name: @radiologist.xray_facility_name } }
    assert_redirected_to radiologist_url(@radiologist)
  end

  test "should destroy radiologist" do
    assert_difference('Radiologist.count', -1) do
      delete radiologist_url(@radiologist)
    end

    assert_redirected_to radiologists_url
  end
end
