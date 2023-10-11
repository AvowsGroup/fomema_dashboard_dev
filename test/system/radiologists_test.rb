require "application_system_test_case"

class RadiologistsTest < ApplicationSystemTestCase
  setup do
    @radiologist = radiologists(:one)
  end

  test "visiting the index" do
    visit radiologists_url
    assert_selector "h1", text: "Radiologists"
  end

  test "creating a Radiologist" do
    visit radiologists_url
    click_on "New Radiologist"

    fill_in "Activated at", with: @radiologist.activated_at
    fill_in "Address1", with: @radiologist.address1
    fill_in "Address2", with: @radiologist.address2
    fill_in "Address3", with: @radiologist.address3
    fill_in "Address4", with: @radiologist.address4
    fill_in "Apc number", with: @radiologist.apc_number
    fill_in "Apc year", with: @radiologist.apc_year
    fill_in "Approval remark", with: @radiologist.approval_remark
    fill_in "Approval status", with: @radiologist.approval_status
    fill_in "Code", with: @radiologist.code
    fill_in "Comment", with: @radiologist.comment
    fill_in "Country", with: @radiologist.country_id
    fill_in "Created by", with: @radiologist.created_by
    fill_in "District health office", with: @radiologist.district_health_office_id
    fill_in "Email", with: @radiologist.email
    fill_in "Fax", with: @radiologist.fax
    fill_in "Gender", with: @radiologist.gender
    fill_in "Icno", with: @radiologist.icno
    check "Is panel xray facility" if @radiologist.is_panel_xray_facility
    check "Is pcr" if @radiologist.is_pcr
    fill_in "Mobile", with: @radiologist.mobile
    fill_in "Name", with: @radiologist.name
    fill_in "Nationality", with: @radiologist.nationality_id
    fill_in "Nsr number", with: @radiologist.nsr_number
    fill_in "Phone", with: @radiologist.phone
    fill_in "Postcode", with: @radiologist.postcode
    fill_in "Qualification", with: @radiologist.qualification
    fill_in "Race", with: @radiologist.race_id
    fill_in "Registration approved at", with: @radiologist.registration_approved_at
    fill_in "Renewal agreement date", with: @radiologist.renewal_agreement_date
    fill_in "State", with: @radiologist.state_id
    fill_in "Status", with: @radiologist.status
    fill_in "Status comment", with: @radiologist.status_comment
    fill_in "Status reason", with: @radiologist.status_reason
    fill_in "String", with: @radiologist.string
    fill_in "Title", with: @radiologist.title_id
    fill_in "Town", with: @radiologist.town_id
    fill_in "Updated by", with: @radiologist.updated_by
    fill_in "User", with: @radiologist.user_id
    fill_in "Xray facility name", with: @radiologist.xray_facility_name
    click_on "Create Radiologist"

    assert_text "Radiologist was successfully created"
    click_on "Back"
  end

  test "updating a Radiologist" do
    visit radiologists_url
    click_on "Edit", match: :first

    fill_in "Activated at", with: @radiologist.activated_at
    fill_in "Address1", with: @radiologist.address1
    fill_in "Address2", with: @radiologist.address2
    fill_in "Address3", with: @radiologist.address3
    fill_in "Address4", with: @radiologist.address4
    fill_in "Apc number", with: @radiologist.apc_number
    fill_in "Apc year", with: @radiologist.apc_year
    fill_in "Approval remark", with: @radiologist.approval_remark
    fill_in "Approval status", with: @radiologist.approval_status
    fill_in "Code", with: @radiologist.code
    fill_in "Comment", with: @radiologist.comment
    fill_in "Country", with: @radiologist.country_id
    fill_in "Created by", with: @radiologist.created_by
    fill_in "District health office", with: @radiologist.district_health_office_id
    fill_in "Email", with: @radiologist.email
    fill_in "Fax", with: @radiologist.fax
    fill_in "Gender", with: @radiologist.gender
    fill_in "Icno", with: @radiologist.icno
    check "Is panel xray facility" if @radiologist.is_panel_xray_facility
    check "Is pcr" if @radiologist.is_pcr
    fill_in "Mobile", with: @radiologist.mobile
    fill_in "Name", with: @radiologist.name
    fill_in "Nationality", with: @radiologist.nationality_id
    fill_in "Nsr number", with: @radiologist.nsr_number
    fill_in "Phone", with: @radiologist.phone
    fill_in "Postcode", with: @radiologist.postcode
    fill_in "Qualification", with: @radiologist.qualification
    fill_in "Race", with: @radiologist.race_id
    fill_in "Registration approved at", with: @radiologist.registration_approved_at
    fill_in "Renewal agreement date", with: @radiologist.renewal_agreement_date
    fill_in "State", with: @radiologist.state_id
    fill_in "Status", with: @radiologist.status
    fill_in "Status comment", with: @radiologist.status_comment
    fill_in "Status reason", with: @radiologist.status_reason
    fill_in "String", with: @radiologist.string
    fill_in "Title", with: @radiologist.title_id
    fill_in "Town", with: @radiologist.town_id
    fill_in "Updated by", with: @radiologist.updated_by
    fill_in "User", with: @radiologist.user_id
    fill_in "Xray facility name", with: @radiologist.xray_facility_name
    click_on "Update Radiologist"

    assert_text "Radiologist was successfully updated"
    click_on "Back"
  end

  test "destroying a Radiologist" do
    visit radiologists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Radiologist was successfully destroyed"
  end
end
