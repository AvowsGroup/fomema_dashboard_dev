require "application_system_test_case"

class LaboratoryExaminationsTest < ApplicationSystemTestCase
  setup do
    @laboratory_examination = laboratory_examinations(:one)
  end

  test "visiting the index" do
    visit laboratory_examinations_url
    assert_selector "h1", text: "Laboratory Examinations"
  end

  test "creating a Laboratory examination" do
    visit laboratory_examinations_url
    click_on "New Laboratory Examination"

    fill_in "Blood group", with: @laboratory_examination.blood_group
    fill_in "Blood group rhesus", with: @laboratory_examination.blood_group_rhesus
    fill_in "Blood specimen barcode", with: @laboratory_examination.blood_specimen_barcode
    fill_in "Created by", with: @laboratory_examination.created_by
    fill_in "Deleted at", with: @laboratory_examination.deleted_at
    fill_in "Laboratory", with: @laboratory_examination.laboratory_id
    fill_in "Laboratory test not done", with: @laboratory_examination.laboratory_test_not_done
    fill_in "Result", with: @laboratory_examination.result
    fill_in "Specimen received date", with: @laboratory_examination.specimen_received_date
    fill_in "Specimen taken date", with: @laboratory_examination.specimen_taken_date
    fill_in "Transaction", with: @laboratory_examination.transaction_id
    fill_in "Transmitted at", with: @laboratory_examination.transmitted_at
    fill_in "Updated by", with: @laboratory_examination.updated_by
    fill_in "Urine specimen barcode", with: @laboratory_examination.urine_specimen_barcode
    check "Web service indicator" if @laboratory_examination.web_service_indicator
    click_on "Create Laboratory examination"

    assert_text "Laboratory examination was successfully created"
    click_on "Back"
  end

  test "updating a Laboratory examination" do
    visit laboratory_examinations_url
    click_on "Edit", match: :first

    fill_in "Blood group", with: @laboratory_examination.blood_group
    fill_in "Blood group rhesus", with: @laboratory_examination.blood_group_rhesus
    fill_in "Blood specimen barcode", with: @laboratory_examination.blood_specimen_barcode
    fill_in "Created by", with: @laboratory_examination.created_by
    fill_in "Deleted at", with: @laboratory_examination.deleted_at
    fill_in "Laboratory", with: @laboratory_examination.laboratory_id
    fill_in "Laboratory test not done", with: @laboratory_examination.laboratory_test_not_done
    fill_in "Result", with: @laboratory_examination.result
    fill_in "Specimen received date", with: @laboratory_examination.specimen_received_date
    fill_in "Specimen taken date", with: @laboratory_examination.specimen_taken_date
    fill_in "Transaction", with: @laboratory_examination.transaction_id
    fill_in "Transmitted at", with: @laboratory_examination.transmitted_at
    fill_in "Updated by", with: @laboratory_examination.updated_by
    fill_in "Urine specimen barcode", with: @laboratory_examination.urine_specimen_barcode
    check "Web service indicator" if @laboratory_examination.web_service_indicator
    click_on "Update Laboratory examination"

    assert_text "Laboratory examination was successfully updated"
    click_on "Back"
  end

  test "destroying a Laboratory examination" do
    visit laboratory_examinations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Laboratory examination was successfully destroyed"
  end
end
