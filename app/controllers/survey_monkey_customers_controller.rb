class SurveyMonkeyCustomersController < ApplicationController
  before_action :set_survey_monkey_customer, only: %i[ show edit update destroy ]

  # GET /survey_monkey_customers or /survey_monkey_customers.json
  def index
    @survey_monkey_customers = SurveyMonkeyCustomer.all
  end

  # GET /survey_monkey_customers/1 or /survey_monkey_customers/1.json
  def show
  end

  # GET /survey_monkey_customers/new
  def new
    @survey_monkey_customer = SurveyMonkeyCustomer.new
  end

  # GET /survey_monkey_customers/1/edit
  def edit
  end

  # POST /survey_monkey_customers or /survey_monkey_customers.json
  def create
    @survey_monkey_customer = SurveyMonkeyCustomer.new(survey_monkey_customer_params)

    respond_to do |format|
      if @survey_monkey_customer.save
        format.html { redirect_to survey_monkey_customer_url(@survey_monkey_customer), notice: "Survey monkey customer was successfully created." }
        format.json { render :show, status: :created, location: @survey_monkey_customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @survey_monkey_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_monkey_customers/1 or /survey_monkey_customers/1.json
  def update
    respond_to do |format|
      if @survey_monkey_customer.update(survey_monkey_customer_params)
        format.html { redirect_to survey_monkey_customer_url(@survey_monkey_customer), notice: "Survey monkey customer was successfully updated." }
        format.json { render :show, status: :ok, location: @survey_monkey_customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @survey_monkey_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_monkey_customers/1 or /survey_monkey_customers/1.json
  def destroy
    @survey_monkey_customer.destroy

    respond_to do |format|
      format.html { redirect_to survey_monkey_customers_url, notice: "Survey monkey customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_monkey_customer
      @survey_monkey_customer = SurveyMonkeyCustomer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_monkey_customer_params
      params.require(:survey_monkey_customer).permit(:respondent_id, :collector_id, :start_date, :end_date, :ip_address, :email_address, :first_name, :last_name, :custom_data, :what_is_your_email_address, :what_is_your_gender, :what_is_your_age, :what_is_customer_suits_you, :which_sector_below_represents, :where_did_you_register_your_worker, :process_emp_reg, :process_worker_reg, :panel_clinic_xray_facilities, :overall_experience_reg_process, :other, :location_panel_clinics, :Fomema_medical_examincation_are_understandable, :medical_Examinations_are_easy_toobtain, :Overall_rate_experience_medical_examination, :Other_medical, :worker_status_found_medical_unsuitable, :undergo_fomema_appeal_process, :tell_experience_appeal_process, :other_appealprocess, :recommend_fomema_friend_collegue, :announcement_business_operator, :delivering_health, :aligned_info_moh_MOHA, :facebook, :twitter, :instagram, :telegram, :other_social, :what_tochange_fomema_socialmedia, :how_do_you_reachus, :how_long_did_you_wait, :is_this_issue_or_problem, :how_would_you_rate, :overall_how_satisfied_are_you)
    end
end
