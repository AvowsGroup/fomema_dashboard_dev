class CustomerSurveysController < ApplicationController
  before_action :set_customer_survey, only: %i[ show edit update destroy ]

  # GET /customer_surveys or /customer_surveys.json
  def index
    @customer_surveys = CustomerSurvey.all
  end

  # GET /customer_surveys/1 or /customer_surveys/1.json
  def show
  end

  # GET /customer_surveys/new
  def new
    @customer_survey = CustomerSurvey.new
  end

  # GET /customer_surveys/1/edit
  def edit
  end

  # POST /customer_surveys or /customer_surveys.json
  def create
    @customer_survey = CustomerSurvey.new(customer_survey_params)

    respond_to do |format|
      if @customer_survey.save
        format.html { redirect_to customer_survey_url(@customer_survey), notice: "Customer survey was successfully created." }
        format.json { render :show, status: :created, location: @customer_survey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_surveys/1 or /customer_surveys/1.json
  def update
    respond_to do |format|
      if @customer_survey.update(customer_survey_params)
        format.html { redirect_to customer_survey_url(@customer_survey), notice: "Customer survey was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_survey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_surveys/1 or /customer_surveys/1.json
  def destroy
    @customer_survey.destroy

    respond_to do |format|
      format.html { redirect_to customer_surveys_url, notice: "Customer survey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_survey
      @customer_survey = CustomerSurvey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_survey_params
      params.require(:customer_survey).permit(:respondent_id, :collector_id, :start_date, :end_date, :ip_address, :email_address, :first_name, :last_name, :custom_data, :what_is_your_email_address, :what_is_your_gender, :what_is_your_age, :what_is_customer_suits_you, :how_do_you_reachus, :how_long_did_you_wait, :is_this_issue_or_problem, :how_would_you_rate, :overall_how_satisfied_are_you)
    end
end
